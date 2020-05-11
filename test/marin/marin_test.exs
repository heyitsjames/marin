defmodule MarinTest do
  use Marin.DataCase

  import Mockery

  alias Marin.{
    Events,
    Races,
    Participants
  }

  alias Marin.Races.Scraper
  alias Marin.Participants.Client, as: ParticipantsClient

  describe "Marin.sync_races_and_events" do
    test "syncs correctly" do
      results = %{
        "IRONMAN St. George" => [
          %{
            external_event_id: "0B18D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2012 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2012
          },
          %{
            external_event_id: "EF16D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2011 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2011
          },
          %{
            external_event_id: "0316D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2010 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2010
          }
        ]
      }

      mock(Scraper, :get_all_race_data, {:ok, results})

      Marin.sync_races_and_events()

      assert Enum.count(Events.list_events()) == 3
      assert Enum.count(Races.list_races()) == 1
    end

    test "if race already synced, don't update uuid or id or inserted_at for the race" do
      results = %{
        "IRONMAN St. George" => [
          %{
            external_event_id: "0B18D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2012 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2012
          },
          %{
            external_event_id: "EF16D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2011 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2011
          },
          %{
            external_event_id: "0316D0B1-4EAE-E111-80AE-005056956277",
            distance: "140.6",
            full_name: "2010 IRONMAN St. George",
            location: "St. George",
            name: "IRONMAN St. George",
            year: 2010
          }
        ]
      }

      mock(Scraper, :get_all_race_data, {:ok, results})

      # call once
      Marin.sync_races_and_events()

      races = Races.list_races()
      events = Events.list_events()

      assert Enum.count(races) == 1
      assert Enum.count(events) == 3

      first_race = List.first(races)

      # call again
      Marin.sync_races_and_events()

      races = Races.list_races()
      events = Events.list_events()

      assert Enum.count(races) == 1
      assert Enum.count(events) == 3

      assert List.first(races).uuid == first_race.uuid
      assert List.first(races).id == first_race.id
      assert List.first(races).inserted_at == first_race.inserted_at
    end
  end

  describe "Marin.sync_participants_for_event/1" do
    test "syncs correctly" do
      event = Factory.insert(:event)

      data = [
        %{
          "ResultId" => "150F343E-C023-43E2-A55A-DF343D2A44D0",
          "SwimTime" => 2896,
          "EventStatus" => "Finish",
          "Contact" => %{"FullName" => "Guilherme Manocchio", "Gender" => "M"},
          "SwimRankGender" => 3,
          "FinishTimeConverted" => "8:14:56",
          "Transition1TimeConverted" => "00:03:40",
          "FinishTime" => 29696,
          "BikeRankOverall" => 5,
          "ContactId" => "1F168292-3200-495D-8D3B-65A48CD9BB16",
          "Transition2TimeConverted" => "00:02:02",
          "BikeRankGroup" => 3,
          "FinishRankGroup" => 1,
          "SwimTimeConverted" => "00:48:16",
          "Badge_Result" => nil,
          "RunRankOverall" => 1,
          "FinishRankGender" => 1,
          "Country" => %{"ISO2" => "BR"},
          "AgeGroup" => "MPRO",
          "BikeRankGender" => 5,
          "CountryRepresentingISONumeric" => 76,
          "BikeTimeConverted" => "4:26:43",
          "Transition2Time" => 122,
          "SubEventId" => "D0A25579-F64D-4E47-84A9-B0C97CEABCAF",
          "SyncDate" => "2019-08-25T20:24:19.300Z",
          "RunTime" => 10455,
          "RunTimeConverted" => "2:54:15",
          "BibNumber" => 7,
          "RunRankGender" => 1,
          "CountryISO2" => "BR",
          "Transition1Time" => 220,
          "SubeventName" => "N/A",
          "BikeTime" => 16003,
          "RankPoints" => 5000,
          "FinishRankOverall" => 1,
          "RunRankGroup" => 1,
          "SwimRankOverall" => 3,
          "SwimRankGroup" => 3
        },
        %{
          "ResultId" => "DAFFE8C9-A07F-4851-A41C-9235F4347E3C",
          "SwimTime" => 2893,
          "EventStatus" => "Finish",
          "Contact" => %{"FullName" => "Henrik Hyldelund", "Gender" => "M"},
          "SwimRankGender" => 2,
          "FinishTimeConverted" => "8:21:51",
          "Transition1TimeConverted" => "00:02:13",
          "FinishTime" => 30111,
          "BikeRankOverall" => 4,
          "ContactId" => "155BF5BD-4E73-4155-BF98-5FBD0B716AEF",
          "Transition2TimeConverted" => "00:01:47",
          "BikeRankGroup" => 2,
          "FinishRankGroup" => 2,
          "SwimTimeConverted" => "00:48:13",
          "Badge_Result" => nil,
          "RunRankOverall" => 2,
          "FinishRankGender" => 2,
          "Country" => %{"ISO2" => "DK"},
          "AgeGroup" => "MPRO",
          "BikeRankGender" => 4,
          "CountryRepresentingISONumeric" => 208,
          "BikeTimeConverted" => "4:27:07",
          "Transition2Time" => 107,
          "SubEventId" => "D0A25579-F64D-4E47-84A9-B0C97CEABCAF",
          "SyncDate" => "2019-08-15T15:35:53.620Z",
          "RunTime" => 10951,
          "RunTimeConverted" => "3:02:31",
          "BibNumber" => 1,
          "RunRankGender" => 2,
          "CountryISO2" => "DK",
          "Transition1Time" => 133,
          "SubeventName" => "N/A",
          "BikeTime" => 16027,
          "RankPoints" => 4917,
          "FinishRankOverall" => 2,
          "RunRankGroup" => 2,
          "SwimRankOverall" => 2,
          "SwimRankGroup" => 2
        }
      ]

      mock(ParticipantsClient, :get_participants_for_event!, data)

      Marin.sync_participants_for_event(event.id)

      assert Enum.count(Participants.list_participants()) == 2
    end
  end
end
