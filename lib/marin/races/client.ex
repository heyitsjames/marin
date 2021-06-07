defmodule Marin.Races.Client do
  @moduledoc """
    HTTP Client for getting race data
  """

  require Logger
  alias Marin.HttpClient

  @races_url "https://api.competitor.com/public/events?$sort%5BDate%5D=1&$limit=200"

  def get_races() do
    # get initial count of all the races
    # somehow only get the newest races and don't try to download older ones
    Logger.info("Requesting #{@races_url}")

    case HttpClient.fetch_data_from_url(@races_url) do
      {:ok, response} ->
        results =
          response
          |> Map.get(:body)
          |> List.first()

        {:ok, results}

      {:error, error} ->
        {:error, error}
    end
  end
end
