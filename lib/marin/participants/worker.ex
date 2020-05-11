defmodule Marin.Participants.Worker do
  alias Marin.Events
  alias Verk.Job
  import Mockery.Macro

  def perform(event_uuid) do
    event = Events.get_event!(event_uuid)

    Marin.sync_participants_for_event(event.id)
  end

  def scrape_participant_data_for_event(event_uuid) do
    mockable(Verk).enqueue(%Job{
      queue: :participants,
      class: __MODULE__,
      args: [event_uuid]
    })
  end
end
