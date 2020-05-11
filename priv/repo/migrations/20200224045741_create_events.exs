defmodule Marin.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :external_event_id, :string, null: false
      add :year, :integer, null: false
      add :uuid, :uuid, null: false
      add :race_id, references("races"), null: false

      timestamps()
    end

    create index(:events, [:race_id])
    create unique_index(:events, [:external_event_id])
  end
end
