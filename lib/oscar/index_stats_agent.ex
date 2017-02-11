defmodule Oscar.IndexStatsAgent do

  def start_link do
    Agent.start_link(fn -> %Oscar.IndexStats{} end)
  end

  def increment_unique_terms(agent, count \\ 1) do
    Agent.cast(agent, fn(stats) ->
      # update(map, key, initial, (value -> value)) :: map
      Map.update(stats, :num_unique_terms, count, &(&1 + count))
    end)
  end

  def increment_num_docs(agent, count \\ 1) do
    Agent.cast(agent, fn(stats) ->
      Map.update(stats, :num_documents, count, &(&1 + count))
    end)
  end

  def increment_terms(agent, count \\ 1) do
    Agent.cast(agent, fn(stats) ->
      Map.update(stats, :num_terms, count, &(&1 + count))
    end)
  end

  def get_index_stats(agent) do
    Agent.get(agent, &(&1))
  end

end
