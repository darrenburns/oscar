defmodule Oscar.Index do

  @doc """
  Construct a new index process
  """
  def start_link do
    {:ok, stats_agent} = Oscar.IndexStatsAgent.start_link
    Agent.start_link(fn -> %{stats: stats_agent} end)
  end

  @doc """
  Get a postings list for `term` from `index`
  """
  def get_postings(index, term, field_name) do
    Agent.get(index, fn(map) ->
      {field_name, Map.get(map, term)}
    end)
  end

  @doc """
  Add a term to an index
  """
  def put_term(idx_agent, term, doc_id, count \\ 1) when count > 0 do
    Agent.update(idx_agent, fn(idx) ->
      # Update index statistics with new unique term information
      stats_agent = Map.fetch!(idx, :stats)
      Oscar.IndexStatsAgent.increment_terms(stats_agent)
      # Check if the term aleady exists in the index
      if Map.has_key?(idx, term) do
        # The result of the below call (the new index) is returned
        {old_state, new_state} = Map.get_and_update(idx, term, fn(postings) ->
          # If the doc_id is not already in the postings list
          postings_item = List.keytake(postings, doc_id, 0)
          if is_nil(postings_item) do
            # Add the doc_id, count to the term postings
            {idx, [{doc_id, count}] ++ postings}
          else
            # Otherwise update the doc_id, count
            postings_item = elem(postings_item, 0)
            updated_postings = List.keyreplace(postings, doc_id, 0, {doc_id, count + elem(postings_item, 1)})
            {idx, updated_postings}
          end
        end)
        new_state
      else
        Oscar.IndexStatsAgent.increment_num_docs(stats_agent)
        Oscar.IndexStatsAgent.increment_unique_terms(stats_agent)
        # New term added to the index
        Map.put(idx, term, [{doc_id, count}])
      end
    end)
  end

  # TODO, add terms in one go, rather than restarting
  def put_terms(idx_agent, terms, doc_id) do
    terms |> Enum.each(&Oscar.Index.put_term(idx_agent, &1, doc_id))
  end

  def get_stats(agent) do
    stats_agent = Agent.get(agent, &Map.get(&1, :stats))
    Oscar.IndexStatsAgent.get_index_stats(stats_agent)
  end

  def increment_num_docs(field_agent) do
    Agent.cast(field_agent, fn(map) ->
      stats_agent = Map.get(map, :stats)
      Oscar.IndexStatsAgent.increment_num_docs(stats_agent)
      map
    end)
  end

end
