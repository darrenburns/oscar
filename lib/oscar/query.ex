defmodule Oscar.Query do

  def do_query(query) do
    # TODO
  end

  def do_query(query, field) do
    IO.puts "=== Starting query: #{query} ==="
    # tokenise the query
    tokens = Oscar.Tokeniser.tokenise(query)
    IO.puts "= Query tokens: #{inspect tokens} ="
    token_doc_freqs = Enum.map(tokens, fn(token) ->
      IO.puts "Token: `#{token}`. Postings: #{inspect Oscar.get_postings(token)}"
      [{_, postings}] = Oscar.get_postings(token)
      |> Enum.filter(fn({f, _}) -> f == field end)
      IO.puts "Postings filtered for field: #{inspect postings}"
      {token, postings}
      end)
    |> Oscar.Scoring.get_scores
    IO.puts "after flat_map: #{inspect token_doc_freqs}"
  end

  def do_query(query, field) when is_list(field) do
    # TODO
  end

end
