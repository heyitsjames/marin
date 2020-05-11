defmodule Marin.Participants do
  @moduledoc """
  The Participants context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Marin.Participants.Participant
  alias Marin.Repo
  alias Marin.Utils

  def list_participants do
    Repo.all(Participant)
  end

  def get_participant!(id), do: Repo.get!(Participant, id)

  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  def create_participants_for_event(participants, event_id) do
    participants
    |> Enum.map(&prepare_participant(&1, event_id))
    |> List.flatten()
    |> Enum.chunk_every(200)
    |> Enum.map(&insert_chunk(&1))
  end

  def get_participant_count_for_event(event_id) do
    query =
      from p in Participant,
        where: p.event_id == ^event_id,
        select: count(p.id)

    Repo.one(query)
  end

  defp prepare_participant(participant, event_id) do
    attrs = Map.put(participant, :event_id, event_id)
    changeset = Participant.changeset(%Participant{}, attrs)

    case changeset.valid? do
      true ->
        changeset
        |> apply_changes()
        |> Utils.struct_to_map()
        |> Map.drop([:id, :inserted_at, :updated_at])
        |> Map.put(:inserted_at, Utils.ecto_utc_now())
        |> Map.put(:updated_at, Utils.ecto_utc_now())
        |> Map.put(:event_id, event_id)

      false ->
        raise "Participants failed here... #{inspect(changeset)}"
    end
  end

  defp insert_chunk(rows) do
    Repo.insert_all(Participant, rows,
      on_conflict: :nothing,
      conflict_target: [:event_id, :external_contact_id]
    )
  end
end
