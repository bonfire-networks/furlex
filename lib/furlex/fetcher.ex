defmodule Furlex.Fetcher do
  @moduledoc """
  A module for fetching body data for a given url
  """
  use Tesla
  plug Tesla.Middleware.FollowRedirects, max_redirects: 3

  require Logger

  alias Furlex.Oembed

  @json_library Application.get_env(:furlex, :json_library, Jason)

  @doc """
  Fetches a url and extracts the body
  """
  @spec fetch(String.t(), List.t()) :: {:ok, String.t(), Integer.t()} | {:error, Atom.t()}
  def fetch(url, opts \\ []) do
    case get(url, opts) do
      {:ok, %{body: body, status: status_code}} -> {:ok, body, status_code}
      other                                     -> other
    end
  end

  @doc """
  Fetches oembed data for the given url
  """
  @spec fetch_oembed(String.t(), List.t()) :: {:ok, String.t()} | {:ok, nil} | {:error, Atom.t()}
  def fetch_oembed(url, opts \\ []) do
    detect_endpoint = Oembed.endpoint_from_url(url)
    with {:ok, endpoint} <- detect_endpoint,
         {:ok, body, 200} <- fetch(endpoint, Keyword.put(opts, :query, %{"url" => url})),
         {:ok, data}     <- @json_library.decode(body)
    do
      {:ok, data}
    else
      {:error, :no_oembed_provider} ->
        {:ok, nil}

      other ->
        "Could not fetch oembed for #{inspect(url)} from #{inspect detect_endpoint}: #{inspect(other)}"
        |> Logger.error()

        {:ok, nil}
    end
  end
end
