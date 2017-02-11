defmodule Oscar.Exceptions.FieldsNotSpecifiedError do

  defexception message: """
    You must specify the fields you wish to index
    inside Oscar.start/1.
  """

end
