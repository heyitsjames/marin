defmodule Marin.Participants.FieldMapperTest do
  use Marin.DataCase

  alias Marin.Participants.{
    FieldMapper,
    Participant
  }

  describe "FieldMapper.map_participant/1" do
    test "maps him good" do
      participant = %{
        "ResultId" => "B615F376-0D43-45D4-9810-62D4DA6147A6",
        "SwimTime" => 1544,
        "EventStatus" => "Finish",
        "Contact" => %{"FullName" => "Matt Trautman", "Gender" => "M"},
        "SwimRankGender" => 5,
        "FinishTimeConverted" => "4:02:59",
        "Transition1TimeConverted" => "00:02:30",
        "FinishTime" => 14579,
        "BikeRankOverall" => 1,
        "ContactId" => "7582F18A-068E-4659-BEE4-655450E8DD66",
        "Transition2TimeConverted" => "00:01:47",
        "BikeRankGroup" => 1,
        "FinishRankGroup" => 1,
        "SwimTimeConverted" => "00:25:44",
        "Badge_Result" => nil,
        "RunRankOverall" => 1,
        "FinishRankGender" => 1,
        "Country" => %{"ISO2" => "ZA"},
        "AgeGroup" => "MPRO",
        "BikeRankGender" => 1,
        "CountryRepresentingISONumeric" => 710,
        "BikeTimeConverted" => "2:17:16",
        "Transition2Time" => 107,
        "SubEventId" => "51743582-408D-E911-A978-000D3A37468C",
        "SyncDate" => "2020-01-26T20:30:35.930Z",
        "RunTime" => 4543,
        "RunTimeConverted" => "1:15:43",
        "BibNumber" => 2,
        "RunRankGender" => 1,
        "CountryISO2" => "ZA",
        "Transition1Time" => 150,
        "SubeventName" => "N/A",
        "BikeTime" => 8236,
        "RankPoints" => 3500,
        "FinishRankOverall" => 1,
        "RunRankGroup" => 1,
        "SwimRankOverall" => 6,
        "SwimRankGroup" => 5
      }

      attrs = FieldMapper.map_participant(participant)

      assert Participant.changeset(%Participant{}, attrs).valid?
    end
  end
end
