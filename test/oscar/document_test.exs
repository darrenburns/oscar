defmodule Oscar.DocumentTest do
  use ExUnit.Case, async: true

  setup_all do
    HTTPoison.start
    {:ok, html: """
      <html>
      <title> Hello, World!!  </title>
      <body>
        <div class="example">Body Text</div>
        <div>Hello</div>
      </body>
      </html>
    """}
  end

  test "parser should find correct headings in html", %{html: html} do
    assert Oscar.Parser.parse(html).tokenised_fields["title"]
      == ["hello", "world"]
  end

  test "parser should find correct body text in html", %{html: html} do
    assert Oscar.Parser.parse(html).tokenised_fields["body"]
      == ["body", "text", "hello"]
  end

end
