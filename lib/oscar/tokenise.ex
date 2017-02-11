defprotocol Oscar.Tokeniser do
  def tokenise(document)
end

defimpl Oscar.Tokeniser, for: BitString do
  # Naive tokenisation on all document fields
  def tokenise(document) do
    String.split(document)
    |> Enum.map(fn(str) ->
        str
        |> String.strip
        |> String.replace(~r/[^\w\s]|_/, "")
        |> String.downcase
      end)
  end
end
