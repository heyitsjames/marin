defmodule Marin.Repo.Migrations.AddFirstNameLastNameIndexesOnParticipants do
  use Ecto.Migration

  def change do
    create index(:participants, [:last_name, :first_name])
  end
end
