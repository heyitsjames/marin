defmodule Marin.Races.Client do
  @moduledoc """
    HTTP Client for getting race data
  """

  require Logger

  @races_url "https://weh-api-public.azureedge.net/hasresults.json"

  def get_races() do
    Logger.info("Requesting #{@races_url}")

    case Mojito.request(method: :get, url: @races_url) do
      {:ok, response} ->
        results =
          response
          |> Map.get(:body)
          |> Jason.decode!()
          |> Map.get("cache")
          |> Map.get("wrapped")
          |> List.first()

        {:ok, results}

      {:error, error} ->
        {:error, error}
    end
  end
end
