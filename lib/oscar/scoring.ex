defmodule Oscar.Scoring do

  @doc """
  Converts a structure of the form:

    [{"term1", [{doc_id, count},...]}, ...]

  into {doc_id, score} pairs (descending order of score)
  """
  def get_scores(query_term_freqs, model \\ :tf) do
    case model do
      :tf ->

    end
  end

  @doc """
  Calculate the term frequency score
  """
  def tf(doc_id, term) do
    {doc_id, 1}  #TODO stub
  end

  @doc """
  Calculate the term frequency score
  """
  def tf(doc_id, term, field) do
    {doc_id, 1}
  end

end
