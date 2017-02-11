defmodule Oscar.IndexTest do
  use ExUnit.Case

  setup_all do
    Oscar.start(fields: ["title", "body"])
    :ok
  end

  setup_all do
    simple_html = """
      <html>
      <title>Hello</title>
      <body>
        <div class="example">Hello</div>
        <div>World.</div>
      </body>
      </html>
    """
    html = """
      <html>
      <title> Hello, hiya!!  </title>
      <body>
        <div class="example">Body Text </div>
        <div>Hello, Hello sweet world! I am world. Hello...</div>
      </body>
      </html>
    """
    {:ok, html: html, simple_html: simple_html}
  end

  # test "stores value by key", %{index: index} do
  #   # Add 1 occurrence of "Darren" to doc_id = 1
  #   Oscar.Index.put_term(index, "Darren", 1)
  #   assert Oscar.Index.get_postings(index, "Darren") == [{1, 1}]
  #   Oscar.Index.put_term(index, "Darren", 1, 4)
  #   assert Oscar.Index.get_postings(index, "Darren") == [{1, 5}]
  # end
  #
  # test "negative term counts raise", %{index: index} do
  #   assert_raise FunctionClauseError, fn ->
  #     Oscar.Index.put_term(index, "Darren", 1, -1)
  #   end
  # end

  test "add documents to index", %{simple_html: simple_html} do
    # Oscar.Indexer.add_document(simple_html, 1)
    # assert Oscar.get_postings("hello") == [{"body", [{1,1}]}, {"title", [{1,1}]}]
    # Oscar.Indexer.add_document(simple_html, 2)
    # assert Oscar.get_postings("hello") == [{"body", [{2,1}, {1,1}]}, {"title", [{2,1}, {1,1}]}]
  end

  test "correct index statistics maintained", %{simple_html: simple_html, html: html} do
    Oscar.Indexer.add_document(simple_html, 1)
    Oscar.Indexer.add_document(html, 2)
    IO.inspect Oscar.get_stats("body")
  end

end
