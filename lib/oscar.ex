defmodule Oscar do

  # TODO Options can specify which fields to index, etc.
  def start(options \\ []) do
    if length(Keyword.get(options, :fields)) == 0 do
      raise Oscar.Exceptions.FieldsNotSpecifiedError
    end
    Oscar.IndexRegistry.start_link(options)
  end

  def get_postings(term) do
    Oscar.IndexRegistry.get_postings(term)
  end

  def get_indexed_fields do
    Oscar.IndexRegistry.active_fields
  end

  def get_stats(field) do
    Oscar.IndexRegistry.get_stats(field)
  end

end
