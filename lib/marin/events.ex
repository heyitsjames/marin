defmodule Marin.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Marin.Repo

  alias Marin.Events.Event
  alias Marin.Utils

  def list_events do
    Repo.all(Event)
  end

  def list_events_with_no_participants do
    query =
      from event in Event,
        left_join: participants in assoc(event, :participants),
        where: is_nil(participants.id)

    Repo.all(query)
  end

  def get_event!(uuid) when is_binary(uuid), do: Repo.get_by!(Event, uuid: uuid)
  def get_event!(id), do: Repo.get!(Event, id)

  def get_event_by(field, value), do: Repo.get_by(Event, [{field, value}])

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def sync_all_events(events_by_race_id) do
    events_by_race_id
    |> Enum.map(fn {race_id, events} ->
      Enum.map(events, fn event ->
        prepare_event(race_id, event)
      end)
    end)
    |> List.flatten()
    |> Enum.chunk_every(200)
    |> Enum.map(&insert_chunk(&1))
  end

  def get_events_with_no_participants() do
    query =
      from e in Event,
        left_join: p in assoc(e, :participants),
        having: count(p.id) == 0,
        group_by: e.id

    Repo.all(query)
  end

  defp prepare_event(race_id, event) do
    params = %{
      race_id: race_id,
      external_event_id: event.external_event_id,
      year: event.year
    }

    changeset = Event.changeset(%Event{}, params)

    case changeset.valid? do
      true ->
        changeset
        |> apply_changes()
        |> Utils.struct_to_map()
        |> Map.take([:race_id, :external_event_id, :uuid, :year])
        |> Map.put(:inserted_at, Utils.ecto_utc_now())
        |> Map.put(:updated_at, Utils.ecto_utc_now())

      false ->
        raise "Events failed here... #{inspect(changeset)}"
    end
  end

  defp insert_chunk(rows) do
    Repo.insert_all(Event, rows,
      on_conflict: :nothing,
      conflict_target: [:external_event_id]
    )
  end
end
