defmodule Marin.Events.Event do
  use Marin.Schema
  import Ecto.Changeset

  alias Marin.Participants.Participant
  alias Marin.Races.Race

  @fields [
    :external_event_id,
    :race_id,
    :uuid,
    :year
  ]

  schema "events" do
    field :external_event_id, :string
    field :year, :integer
    field :uuid, Ecto.UUID

    belongs_to :race, Race
    has_many :participants, Participant

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields)
    |> put_uuid()
    |> validate_required(@fields)
  end
end
