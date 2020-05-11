defmodule Marin.RacesTest do
  use Marin.DataCase

  alias Marin.Races

  describe "races" do
    alias Marin.Races.Race

    @valid_attrs %{distance: "some distance", location: "some location", name: "some name"}
    @update_attrs %{
      distance: "some updated distance",
      location: "some updated location",
      name: "some updated name"
    }
    @invalid_attrs %{distance: nil, location: nil, name: nil}

    def race_fixture(attrs \\ %{}) do
      {:ok, race} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Races.create_race()

      race
    end

    test "list_races/0 returns all races" do
      race = race_fixture()
      assert Races.list_races() == [race]
    end

    test "get_race!/1 returns the race with given id" do
      race = race_fixture()
      assert Races.get_race!(race.id) == race
    end

    test "create_race/1 with valid data creates a race" do
      assert {:ok, %Race{} = race} = Races.create_race(@valid_attrs)
      assert race.distance == "some distance"
      assert race.location == "some location"
      assert race.name == "some name"
    end

    test "create_race/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Races.create_race(@invalid_attrs)
    end

    test "update_race/2 with valid data updates the race" do
      race = race_fixture()
      assert {:ok, %Race{} = race} = Races.update_race(race, @update_attrs)
      assert race.distance == "some updated distance"
      assert race.location == "some updated location"
      assert race.name == "some updated name"
    end

    test "update_race/2 with invalid data returns error changeset" do
      race = race_fixture()
      assert {:error, %Ecto.Changeset{}} = Races.update_race(race, @invalid_attrs)
      assert race == Races.get_race!(race.id)
    end

    test "delete_race/1 deletes the race" do
      race = race_fixture()
      assert {:ok, %Race{}} = Races.delete_race(race)
      assert_raise Ecto.NoResultsError, fn -> Races.get_race!(race.id) end
    end

    test "sync_all_races adds all new races" do
      data = %{
        "IRONMAN 70.3 Hefei" => [
          %{
            external_event_id: "6D648E0A-FABA-E511-940C-005056951BF1",
            distance: "70.3",
            full_name: "2016 IRONMAN 70.3 Hefei",
            location: "Hefei",
            name: "IRONMAN 70.3 Hefei",
            year: 2016
          }
        ]
      }

      Races.sync_all_races(data)
    end
  end
end
