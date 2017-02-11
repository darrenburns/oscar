defprotocol Oscar.Parser do

  @doc """
  Parse a textual document into a Document struct
  """
  def parse(text)

end

defimpl Oscar.Parser, for: BitString do

  def parse(text, doc_type \\ :html) do
    case doc_type do
      # TODO: Make dynamic based on config, rather than fixed fields
      :html ->
        %Oscar.Document{
          tokenised_fields: %{
            "title" => Floki.find(text, "title")
                    |> Floki.text
                    |> Oscar.Tokeniser.tokenise,
            "body" => Floki.find(text, "body")
                    |> Floki.text(sep: " ")
                    |> Oscar.Tokeniser.tokenise
          },
          metadata: [doc_type: doc_type]
        }
    end
  end

end
