defmodule Marin.Participants.ParticipantData do
  @moduledoc """
    Idk what this is going to be
  """
  use Marin.Schema
  require Logger
  import Ecto.Changeset

  alias Marin.CountryCodes
  alias Marin.Events.Event

  @mapping %{
    "AgeGroup" => :age_group,
    "BibNumber" => :bib_number,
    "BikeRankGender" => :gender_bike_rank,
    "BikeRankGroup" => :age_group_bike_rank,
    "BikeRankOverall" => :overall_bike_rank,
    "BikeTime" => :bike_time,
    "BikeTimeConverted" => :converted_bike_time,
    "Contact" => :participant_info,
    "ContactId" => :external_contact_id,
    "CountryISO2" => :iso_country_code,
    "EventStatus" => :finish_status,
    "FinishRankGender" => :gender_finish_rank,
    "FinishRankGroup" => :age_group_finish_rank,
    "FinishRankOverall" => :overall_finish_rank,
    "FinishTime" => :finish_time,
    "FinishTimeConverted" => :converted_finish_time,
    "RankPoints" => :rank_points,
    "ResultId" => :external_result_id,
    "RunRankGender" => :gender_run_rank,
    "RunRankGroup" => :age_group_run_rank,
    "RunRankOverall" => :overall_run_rank,
    "RunTime" => :run_time,
    "RunTimeConverted" => :converted_run_time,
    "SwimRankGender" => :gender_swim_rank,
    "SwimRankGroup" => :age_group_swim_rank,
    "SwimRankOverall" => :overall_swim_rank,
    "SwimTime" => :swim_time,
    "SwimTimeConverted" => :converted_swim_time,
    "Transition1Time" => :t1_time,
    "Transition1TimeConverted" => :converted_t1_time,
    "Transition2Time" => :t2_time,
    "Transition2TimeConverted" => :converted_t2_time
  }

  @fields [
    "AgeGroup",
    "BibNumber",
    "BikeRankGender",
    "BikeRankGroup",
    "BikeRankOverall",
    "BikeTime",
    "BikeTimeConverted",
    "Contact",
    "ContactId",
    "CountryISO2",
    "EventStatus",
    "FinishRankGender",
    "FinishRankGroup",
    "FinishRankOverall",
    "FinishTime",
    "FinishTimeConverted",
    "FirstName",
    "LastName",
    "RankPoints",
    "ResultId",
    "RunRankGender",
    "RunRankGroup",
    "RunRankOverall",
    "RunTime",
    "RunTimeConverted",
    "SwimRankGender",
    "SwimRankGroup",
    "SwimRankOverall",
    "SwimTime",
    "SwimTimeConverted",
    "Transition1Time",
    "Transition1TimeConverted",
    "Transition2Time",
    "Transition2TimeConverted"
  ]

  schema "participant_data" do
    field :AgeGroup, :string
    field :BibNumber, :integer
    field :BikeRankGender, :integer
    field :BikeRankGroup, :integer
    field :BikeRankOverall, :integer
    field :BikeTime, :integer
    field :BikeTimeConverted, :integer
    field :Contact, :map
    field :ContactId, :string
    field :CountryISO2, :string
    field :EventStatus, :string
    field :FinishRankGender, :string
    field :FinishRankGroup, :string
    field :FinishRankOverall, :string
    field :FinishTime, :string
    field :FinishTimeConverted, :string
    field :RankPoints, :integer
    field :ResultId, :string
    field :RunRankGender, :integer
    field :RunRankGroup, :integer
    field :RunRankOverall, :integer
    field :RunTime, :integer
    field :RunTimeConverted, :string
    field :SwimRankGender, :integer
    field :SwimRankGroup, :integer
    field :SwimRankOverall, :integer
    field :SwimTime, :integer
    field :SwimTimeConverted, :integer, default: 0
    field :Transition1Time, :integer
    field :Transition1TimeConverted, :integer
    field :Transition2Time, :integer
    field :Transition2TimeConverted, :integer
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  def get_field(external_name), do: Map.get(@mapping, external_name)

  def map_participant(external_participant) do
    external_participant
    |> map_keys()
    |> put_name()
    |> put_gender()
    |> put_country()
  end

  defp map_keys(participant) do
    Enum.reduce(participant, %{}, fn {key, value}, acc ->
      atom_key = get_field(key)

      if is_nil(atom_key) do
        acc
      else
        Map.put(acc, atom_key, value)
      end
    end)
  end

  defp put_name(participant) do
    info = participant.participant_info

    {first_name, last_name} =
      case info["FullName"] do
        nil ->
          {"-", "-"}

        full_name ->
          [first_name | rest] = String.split(full_name, " ")
          last_name = if Enum.empty?(rest), do: "-", else: Enum.join(rest, " ")
          {first_name, last_name}
      end

    participant
    |> Map.put(:first_name, first_name)
    |> Map.put(:last_name, last_name)
  end

  defp put_gender(participant) do
    case participant.participant_info["Gender"] do
      "M" -> Map.put(participant, :gender, "Male")
      "F" -> Map.put(participant, :gender, "Female")
      _ -> Map.put(participant, :gender, "N/A")
    end
  end

  defp put_country(participant) do
    country = CountryCodes.get_country_name(participant.iso_country_code)
    Map.put(participant, :country, country)
  end
end
