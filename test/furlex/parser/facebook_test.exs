defmodule Unfurl.Parser.FacebookTest do
  use ExUnit.Case

  alias Unfurl.Parser.Facebook

  doctest Facebook

  test "parses Facebook Open Graph" do
    html =
      "<html><head><meta property=\"og:url\" " <>
        "content=\"www.example.com\"/></head></html>"

    assert {:ok, %{"url" => "www.example.com"}} == Facebook.parse(html)
  end
end
