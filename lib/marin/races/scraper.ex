defmodule Marin.Races.Scraper do
  @moduledoc """
    Module to get and update races
  """

  require Logger

  alias Marin.Races.Client

  def get_all_race_data() do
    case Client.get_races() do
      {:ok, races} -> {:ok, extract_race_data(races)}
      {:error, error} -> Logger.error(inspect(error))
    end
  end

  defp extract_race_data(races) do
    races
    |> transform_into_proper_map()
    |> sanitize_full_names()
    |> add_race_distance()
    |> add_race_year()
    |> sanitize_race_name()
    |> add_location()
    |> group_by_name()
  end

  defp transform_into_proper_map(races) do
    Enum.map(races, fn race ->
      %{
        full_name: race["SubEvent"],
        external_event_id: race["SubEventId"]
      }
    end)
  end

  defp add_race_distance(races) do
    Enum.reduce(races, [], fn race, acc ->
      is_vr? = String.contains?(Map.get(race, :full_name), "IRONMAN VR")
      is_half? = String.contains?(Map.get(race, :full_name), "70.3")
      is_full? = String.contains?(Map.get(race, :full_name), "IRONMAN") and not is_half?

      distance =
        cond do
          is_vr? -> "Virtual"
          is_full? -> "140.6"
          is_half? -> "70.3"
          true -> nil
        end

      if distance do
        [Map.put(race, :distance, distance) | acc]
      else
        acc
      end
    end)
  end

  defp add_race_year(races) do
    Enum.map(races, fn race ->
      year =
        if race.distance == "Virtual" do
          2020
        else
          race
          |> Map.get(:full_name)
          |> String.split_at(4)
          |> elem(0)
          |> String.to_integer()
        end

      Map.put(race, :year, year)
    end)
  end

  defp sanitize_full_names(races) do
    Enum.map(races, fn race ->
      Map.put(race, :full_name, List.first(String.split(race.full_name, ": Triathlon")))
    end)
  end

  defp sanitize_race_name(races) do
    Enum.map(races, fn race ->
      name_without_year =
        if race.distance == "Virtual" do
          race.full_name
        else
          race
          |> Map.get(:full_name)
          |> String.split_at(5)
          |> elem(1)
        end

      Map.put(race, :name, name_without_year)
    end)
  end

  defp add_location(races) do
    Enum.map(races, fn race ->
      regex = ~r/.* IRONMAN (70.3 )?(?<location>.*)/
      captures = Regex.named_captures(regex, race.full_name)

      location =
        case captures do
          nil -> "N/A"
          _ -> Map.get(captures, "location")
        end

      Map.put(race, :location, location)
    end)
  end

  defp group_by_name(races) do
    Enum.group_by(races, & &1.name)
  end
end
