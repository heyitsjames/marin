defmodule Marin.Schema do
  @moduledoc """
    Module that all models should use
  """

  import Ecto.Changeset

  def put_uuid(changeset) do
    if get_field(changeset, :uuid) do
      changeset
    else
      put_change(changeset, :uuid, Ecto.UUID.generate())
    end
  end

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Marin.Schema, only: [put_uuid: 1]

      @timestamps_opts [type: :utc_datetime]
    end
  end
end
