defmodule Marin.Participants.FieldMapper do
  @moduledoc """
    Field mapper for participant
  """
  alias Marin.CountryCodes
  require Logger

  @mapping %{
    "AgeGroup" => :age_group,
    "BikeRankGroup" => :age_group_bike_rank,
    "FinishRankGroup" => :age_group_finish_rank,
    "RunRankGroup" => :age_group_run_rank,
    "SwimRankGroup" => :age_group_swim_rank,
    "BibNumber" => :bib_number,
    "BikeTime" => :bike_time,
    "BikeTimeConverted" => :converted_bike_time,
    "FinishTimeConverted" => :converted_finish_time,
    "RunTimeConverted" => :converted_run_time,
    "SwimTimeConverted" => :converted_swim_time,
    "Transition1TimeConverted" => :converted_t1_time,
    "Transition2TimeConverted" => :converted_t2_time,
    "ContactId" => :external_contact_id,
    "ResultId" => :external_result_id,
    "EventStatus" => :finish_status,
    "FinishTime" => :finish_time,
    "BikeRankGender" => :gender_bike_rank,
    "FinishRankGender" => :gender_finish_rank,
    "RunRankGender" => :gender_run_rank,
    "SwimRankGender" => :gender_swim_rank,
    "CountryISO2" => :iso_country_code,
    "Contact" => :participant_info,
    "BikeRankOverall" => :overall_bike_rank,
    "FinishRankOverall" => :overall_finish_rank,
    "RunRankOverall" => :overall_run_rank,
    "SwimRankOverall" => :overall_swim_rank,
    "RankPoints" => :rank_points,
    "RunTime" => :run_time,
    "SwimTime" => :swim_time,
    "Transition1Time" => :t1_time,
    "Transition2Time" => :t2_time
  }

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
