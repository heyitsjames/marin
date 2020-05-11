defmodule Marin.Repo.Migrations.AddAgeGroupIndexOnParticipants do
  use Ecto.Migration

  def change do
    create index(:participants, [:age_group])
  end
end
