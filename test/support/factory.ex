defmodule Marin.Factory do
  @moduledoc """
    Factory generation functions for different models, using ExMachina
  """

  use ExMachina.Ecto, repo: Marin.Repo

  alias Marin.{
    Events.Event,
    Races.Race,
    Participants.Participant
  }

  alias Marin.Utils

  def event_factory do
    %Event{
      race: build(:race),
      external_event_id: Utils.random_token(10),
      year: Enum.random(2002..2020),
      uuid: Ecto.UUID.generate()
    }
  end

  def race_factory do
    %Race{
      distance: Enum.random(["70.3", "140.6"]),
      location: "Murica",
      name: "IRONMAN #{Faker.Food.En.dish()}",
      uuid: Ecto.UUID.generate()
    }
  end

  def participant_factory do
    %Participant{
      first_name: Faker.Name.first_name(),
      last_name: Faker.Name.last_name(),
      country: "Murica",
      age_group: Enum.random(["M18-24", "M25-29", "M30-34", "M35-39", "M40-44"]),
      converted_swim_time: "01:11:11",
      converted_bike_time: "02:22:22",
      converted_run_time: "03:33:33",
      converted_finish_time: "04:44:44",
      converted_t1_time: "00:03:00",
      converted_t2_time: "00:03:00",
      swim_time: Enum.random(1800..7200),
      bike_time: Enum.random(1800..7200),
      run_time: Enum.random(1800..7200),
      t1_time: Enum.random(1800..7200),
      t2_time: Enum.random(1800..7200),
      finish_time: Enum.random(1800..7200),
      overall_swim_rank: Enum.random(1..1000),
      overall_bike_rank: Enum.random(1..1000),
      overall_run_rank: Enum.random(1..1000),
      overall_finish_rank: Enum.random(1..1000),
      age_group_swim_rank: Enum.random(1..1000),
      age_group_bike_rank: Enum.random(1..1000),
      age_group_run_rank: Enum.random(1..1000),
      age_group_finish_rank: Enum.random(1..1000),
      gender_swim_rank: Enum.random(1..1000),
      gender_bike_rank: Enum.random(1..1000),
      gender_run_rank: Enum.random(1..1000),
      gender_finish_rank: Enum.random(1..1000),
      rank_points: Enum.random(100..5000),
      bib_number: Enum.random(1..2500),
      finish_status: "Finished",
      external_contact_id: Utils.random_token(20),
      external_result_id: Utils.random_token(20),
      uuid: Ecto.UUID.generate(),
      event: build(:event)
    }
  end
end
