defmodule Marin.Participants.Client do
  @moduledoc """
    HTTP Client for the scraper
  """

  require Logger

  @event_url_base "https://data.competitor.com/result/subevent"
  @event_results_per_page 100

  def get_participants_for_event!(event_id) do
    first_page = request_participants_for_event!(event_id)
    first_page_data = first_page["data"]
    total_results = first_page["total"]

    total_pages =
      total_results
      |> Kernel./(@event_results_per_page)
      |> Float.ceil()
      |> Kernel.trunc()

    1..(total_pages - 1)
    |> Task.async_stream(
      fn page ->
        Process.sleep(100)
        request_participants_for_event!(event_id, page * 100)["data"]
      end,
      timeout: 60_000,
      max_concurrency: 1
    )
    |> Enum.reduce(first_page_data, fn {:ok, result}, acc ->
      [result | acc]
    end)
    |> List.flatten()
    |> Enum.sort_by(& &1["FinishRankOverall"])
  end

  def request_participants_for_event!(event_id, skip \\ 0) do
    params = %{
      "$limit" => @event_results_per_page,
      "$skip" => skip,
      "$sort[FinishRankOverall]" => 1
    }

    encoded_params = URI.encode_query(params)

    full_url = "#{@event_url_base}/#{event_id}?#{encoded_params}"

    Logger.info("Requesting #{full_url}")

    case Mojito.request(method: :get, url: full_url) do
      {:ok, response} ->
        response
        |> Map.get(:body)
        |> Jason.decode!()

      {:error, error} ->
        raise inspect(error)
    end
  end
end
