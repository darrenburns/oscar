defmodule Oscar.IndexRegistry do
  use GenServer

  # Client API
  def start_link(options) do
    # TODO Check which fields are to be indexed, and spawn an Index agent for each field
    # Additionally, we must add these fields to our index registry map

    # TODO This should be run on start up
    GenServer.start_link(__MODULE__, options, [name: IndexRegistry])

  end

  @doc """
  Looks up the index pid for `name` stored in `server`
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Create an index process with the given `name` in `server`
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
  Lists the fields that this index registry maintains indexes for
  """
  def active_fields do
    GenServer.call(IndexRegistry, :active_fields)
  end

  def get_postings(term) do
    GenServer.call(IndexRegistry, {:get_postings, term})
  end

  def get_postings(term, field) do
    GenServer.call(IndexRegistry, {:get_postings, term, field})
  end

  def get_stats(field) do
    GenServer.call(IndexRegistry, {:get_stats, field})
  end

  # Server callbacks
  def init(options) do
    field_names = Keyword.get(options, :fields)
    names = Enum.into(field_names, %{}, fn(item) ->
      {item, Oscar.Index.start_link |> elem(1)}
    end)
    {:ok, names}
  end

  @doc """
  Looks up the index process associated with a document field
  """
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call(:active_fields, _from, names) do
    {:reply, Map.keys(names), names}
  end

  @doc """
  Gets the postings for a term from each field index.
  """
  def handle_call({:get_postings, term}, _from, names) do
    # Propogate call to field index agents
    postings = names
      |> Enum.map(fn({field_name, index_pid}) ->
          Oscar.Index.get_postings(index_pid, term, field_name)
        end)
    {:reply, postings, names}
  end

  @doc """
  Gets the postings for a term for a single field index.
  """
  def handle_call({:get_postings, term, field}, _from, names) do
    # Propogate call to field index agents
    postings = names
      |> Enum.filter_map(
          fn({f, i}) -> f == field end,  # Filter
          fn({field_name, index_pid}) ->  # Map
            Oscar.Index.get_postings(index_pid, term, field_name)
          end)
    {:reply, postings, names}
  end

  def handle_call({:get_stats, field}, _from, names) do
    index_agent = Map.get(names, field)
    stats = Oscar.Index.get_stats(index_agent)
    IO.inspect stats
    {:reply, stats, names}
  end

  def handle_cast({:add_document, document, doc_id}, names) do
    names
    |> Enum.each(fn({name, index}) ->
        Oscar.Index.increment_num_docs(index)
        Oscar.Index.put_terms(index, Map.get(document.tokenised_fields, name), doc_id)
      end)
    {:noreply, names}
  end

  # TODO Creating non-field indexes can be done using the function below
  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, index} = Oscar.Index.start_link
      {:noreply, Map.put(names, name, index)}
    end
  end

end

defprotocol Oscar.Indexer do
  def add_document(document, doc_id)
  def add_document_from_url(url, doc_id)
end

defimpl Oscar.Indexer, for: Oscar.Document do
  def add_document(document, doc_id) do
    GenServer.cast(IndexRegistry, {:add_document, document, doc_id})
  end
end

defimpl Oscar.Indexer, for: BitString do
  def add_document(document, doc_id) do
    # Parse to document and then cast to index registry
    parsed_doc = Oscar.Parser.parse(document)
    GenServer.cast(IndexRegistry, {:add_document, parsed_doc, doc_id})
  end
end
