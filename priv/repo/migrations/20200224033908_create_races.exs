defmodule Marin.Repo.Migrations.CreateRaces do
  use Ecto.Migration

  def change do
    create table(:races) do
      add :name, :string, null: false
      add :distance, :string, null: false
      add :location, :string, null: false
      add :uuid, :uuid, null: false

      timestamps()
    end

    create unique_index("races", [:name])
  end
end
