defmodule Marin.Races.Race do
  @moduledoc """
    Module for the `races` table
  """

  use Marin.Schema

  @fields [
    :distance,
    :location,
    :name
  ]

  schema "races" do
    field :distance, :string
    field :location, :string
    field :name, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  def changeset(race, attrs) do
    race
    |> cast(attrs, @fields)
    |> put_uuid()
    |> validate_required(@fields)
  end
end
