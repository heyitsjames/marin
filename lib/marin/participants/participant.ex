defmodule Marin.Participants.Participant do
  use Marin.Schema
  import Ecto.Changeset

  alias Marin.Events.Event

  @fields [
    :first_name,
    :last_name,
    :country,
    :age_group,
    :converted_swim_time,
    :converted_bike_time,
    :converted_run_time,
    :converted_finish_time,
    :converted_t1_time,
    :converted_t2_time,
    :swim_time,
    :bike_time,
    :run_time,
    :t1_time,
    :t2_time,
    :finish_time,
    :overall_swim_rank,
    :overall_bike_rank,
    :overall_run_rank,
    :overall_finish_rank,
    :age_group_swim_rank,
    :age_group_bike_rank,
    :age_group_run_rank,
    :age_group_finish_rank,
    :gender_swim_rank,
    :gender_bike_rank,
    :gender_run_rank,
    :gender_finish_rank,
    :rank_points,
    :bib_number,
    :finish_status,
    :external_contact_id,
    :external_result_id,
    :uuid
  ]

  schema "participants" do
    field :first_name, :string, default: "-"
    field :last_name, :string, default: "-"
    field :country, :string
    field :age_group, :string, default: "N/A"
    field :converted_swim_time, :string
    field :converted_bike_time, :string
    field :converted_run_time, :string
    field :converted_finish_time, :string
    field :converted_t1_time, :string
    field :converted_t2_time, :string
    field :swim_time, :integer
    field :bike_time, :integer
    field :run_time, :integer
    field :t1_time, :integer
    field :t2_time, :integer
    field :finish_time, :integer
    field :overall_swim_rank, :integer
    field :overall_bike_rank, :integer
    field :overall_run_rank, :integer
    field :overall_finish_rank, :integer
    field :age_group_swim_rank, :integer
    field :age_group_bike_rank, :integer
    field :age_group_run_rank, :integer
    field :age_group_finish_rank, :integer
    field :gender_swim_rank, :integer
    field :gender_bike_rank, :integer
    field :gender_run_rank, :integer
    field :gender_finish_rank, :integer
    field :rank_points, :integer, default: 0
    field :bib_number, :integer
    field :finish_status, :string, default: "N/A"
    field :external_contact_id, :string
    field :external_result_id, :string
    field :uuid, Ecto.UUID

    belongs_to :event, Event

    timestamps()
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, @fields)
    |> put_defaults_for_nils()
    |> put_uuid()
    |> validate_required(@fields)
  end

  defp put_defaults_for_nils(changeset) do
    nil_fields = find_nil_fields_in_changeset(changeset)
    put_defaults_for_nil_fields(changeset, nil_fields)
  end

  defp find_nil_fields_in_changeset(changeset) do
    Enum.reduce(changeset.changes, [], fn {key, value}, acc ->
      case is_nil(value) do
        true -> [key | acc]
        false -> acc
      end
    end)
  end

  defp put_defaults_for_nil_fields(changeset, nil_fields) do
    default_values =
      Enum.reduce(nil_fields, %{}, fn nil_field, acc ->
        case Map.get(__MODULE__.__struct__(), nil_field, nil) do
          nil -> acc
          default_value -> Map.put(acc, nil_field, default_value)
        end
      end)

    change(changeset, default_values)
  end
end
