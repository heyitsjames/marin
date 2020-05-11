defmodule Marin.ParticipantsTest do
  use Marin.DataCase
  alias Marin.Participants
  alias Marin.Participants.Participant

  describe "Participants.create_participants_for_event" do
    test "adds default values for nils" do
      event = Factory.insert(:event)

      data = [
        %{
          # nil values to be added to defaults
          first_name: nil,
          rank_points: nil,
          last_name: nil,
          finish_status: nil,
          age_group_swim_rank: 5,
          participant_info: %{"FullName" => "Matt Trautman", "Gender" => "M"},
          gender: "Male",
          converted_swim_time: "00:25:44",
          gender_finish_rank: 1,
          gender_swim_rank: 5,
          iso_country_code: "ZA",
          bib_number: 2,
          t1_time: 150,
          age_group_bike_rank: 1,
          overall_finish_rank: 1,
          converted_bike_time: "2:17:16",
          gender_bike_rank: 1,
          overall_swim_rank: 6,
          external_contact_id: "7582F18A-068E-4659-BEE4-655450E8DD66",
          overall_bike_rank: 1,
          finish_time: 14579,
          country: "South Africa",
          converted_t1_time: "00:02:30",
          overall_run_rank: 1,
          gender_run_rank: 1,
          age_group: "MPRO",
          bike_time: 8236,
          t2_time: 107,
          run_time: 4543,
          age_group_run_rank: 1,
          converted_t2_time: "00:01:47",
          age_group_finish_rank: 1,
          external_result_id: "B615F376-0D43-45D4-9810-62D4DA6147A6",
          converted_run_time: "1:15:43",
          swim_time: 1544,
          converted_finish_time: "4:02:59"
        }
      ]

      Participants.create_participants_for_event(data, event.id)

      created_participant = Repo.one(Participant)
      assert created_participant.finish_status == "N/A"
      assert created_participant.first_name == "-"
      assert created_participant.last_name == "-"
      assert created_participant.rank_points == 0
    end
  end
end
