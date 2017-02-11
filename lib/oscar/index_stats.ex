defmodule Oscar.IndexStats do
  defstruct num_documents: 0,
            num_unique_terms: 0,  # Size of term lexicon
            num_terms: 0
end
