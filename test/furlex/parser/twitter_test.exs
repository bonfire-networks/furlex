defmodule Unfurl.Parser.TwitterTest do
  use ExUnit.Case

  alias Unfurl.Parser.Twitter

  doctest Twitter

  test "parses Twitter Cards" do
    html =
      "<html><head><meta name=\"twitter:image\" " <>
        "content=\"www.example.com\"/></head></html>"

    assert {:ok,
            %{
              "image" => "www.example.com"
            }} == Twitter.parse(html)
  end
end
