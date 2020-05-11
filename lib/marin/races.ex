defmodule Marin.Races do
  @moduledoc """
  The Races context.
  """

  import Ecto.Changeset

  alias Marin.{
    Races.Race,
    Repo,
    Utils
  }

  def list_races do
    Repo.all(Race)
  end

  def get_race!(id), do: Repo.get!(Race, id)

  def create_race(attrs \\ %{}) do
    %Race{}
    |> Race.changeset(attrs)
    |> Repo.insert()
  end

  def update_race(%Race{} = race, attrs) do
    race
    |> Race.changeset(attrs)
    |> Repo.update()
  end

  def delete_race(%Race{} = race) do
    Repo.delete(race)
  end

  def sync_all_races(race_data) do
    rows =
      Enum.map(race_data, fn {race_name, race_data} ->
        params = %{
          name: race_name,
          location: List.first(race_data).location,
          distance: List.first(race_data).distance
        }

        changeset = Race.changeset(%Race{}, params)

        case changeset.valid? do
          true ->
            changeset
            |> apply_changes()
            |> Utils.struct_to_map()
            |> Map.take([:name, :location, :distance, :uuid])
            |> Map.put(:inserted_at, Utils.ecto_utc_now())
            |> Map.put(:updated_at, Utils.ecto_utc_now())
        end
      end)

    Repo.insert_all(Race, rows,
      on_conflict: {:replace_all_except, [:inserted_at, :uuid, :id]},
      conflict_target: [:name],
      returning: [:id, :name]
    )
  end
end
