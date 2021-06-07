defmodule Marin.HttpClient do
  @moduledoc """
    Http client
  """

  use Tesla
  require Logger
  import Mockery.Macro

  def fetch_data_from_url(url) do
    client = client(url)
    mockable(Tesla).get(client, url)
  end

  def client(url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"wtc_priv_key", "90da38d91a0648f89823e375a43b2dc8"}]}
    ]

    Tesla.client(middleware)
  end
end
