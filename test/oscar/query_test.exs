defmodule Oscar.QueryTest do

  use ExUnit.Case

  setup_all do
    Oscar.start(fields: ["title", "body"])
    :ok
  end

  setup do
    simple_html = """
      <html>
      <title>Hello</title>
      <body>
        <div class="example">Hello world</div>
        <div>World.</div>
      </body>
      </html>
    """
    more_html = """
      <html>
      <title>Cars World</title>
      <body>
        <div class="example">A cars world world world site about cars and stuff.</div>
        <div>car</div>
      </body>
      </html>
    """
    {:ok, simple_html: simple_html, more_html: more_html}
  end

  test "performs query correctly", %{simple_html: simple_html, more_html: more_html} do
    Oscar.Indexer.add_document(simple_html, 1)
    Oscar.Indexer.add_document(more_html, 2)
    :timer.sleep(600) # FIXME change add_document to call rather than cast?
    Oscar.Query.do_query("cars world", "body")
  end

end
