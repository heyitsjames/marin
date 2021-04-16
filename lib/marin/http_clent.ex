defmodule Marin.HttpClient do
  @moduledoc """
    Http client
  """

  use Tesla
  require Logger
  import Mockery.Macro

  def get(url, payload) do
    client = client(url)
    mockable(Tesla).get(client, url, payload)
  end

  def client(url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
