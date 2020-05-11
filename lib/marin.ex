defmodule Marin do
  @moduledoc """
  Marin keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Mockery.Macro

  alias Marin.{
    Events,
    Participants,
    Participants.FieldMapper,
    Participants.Worker,
    Races.Scraper
  }

  alias Marin.{
    Events,
    Races
  }

  alias Marin.Participants.Client, as: ParticipantsClient

  def sync_races_and_events do
    {:ok, results} = mockable(Scraper).get_all_race_data()

    {_total_inserted, races} = Races.sync_all_races(results)

    results_with_race_ids =
      Enum.reduce(races, %{}, fn race, acc ->
        Map.put(acc, race.id, results[race.name])
      end)

    Events.sync_all_events(results_with_race_ids)
  end

  def sync_participants_for_all_events() do
    events = Events.list_events()

    Enum.map(events, fn event ->
      Worker.scrape_participant_data_for_event(event.uuid)
    end)
  end

  def sync_participants_for_new_events() do
  end

  def sync_participants_for_event(event_id) do
    event = Events.get_event!(event_id)
    results = mockable(ParticipantsClient).get_participants_for_event!(event.external_event_id)

    participants = Enum.map(results, &FieldMapper.map_participant(&1))

    Participants.create_participants_for_event(participants, event.id)
  end
end
