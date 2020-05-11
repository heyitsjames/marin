defmodule Marin.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :country, :string, null: false
      add :age_group, :string, null: false
      add :converted_swim_time, :string, null: false
      add :converted_bike_time, :string, null: false
      add :converted_run_time, :string, null: false
      add :converted_finish_time, :string, null: false
      add :converted_t1_time, :string, null: false
      add :converted_t2_time, :string, null: false
      add :swim_time, :integer, null: false
      add :bike_time, :integer, null: false
      add :run_time, :integer, null: false
      add :t1_time, :integer, null: false
      add :t2_time, :integer, null: false
      add :finish_time, :integer, null: false
      add :overall_swim_rank, :integer, null: false
      add :overall_bike_rank, :integer, null: false
      add :overall_run_rank, :integer, null: false
      add :overall_finish_rank, :integer, null: false
      add :age_group_swim_rank, :integer, null: false
      add :age_group_bike_rank, :integer, null: false
      add :age_group_run_rank, :integer, null: false
      add :age_group_finish_rank, :integer, null: false
      add :gender_swim_rank, :integer, null: false
      add :gender_bike_rank, :integer, null: false
      add :gender_run_rank, :integer, null: false
      add :gender_finish_rank, :integer, null: false
      add :rank_points, :integer, null: false
      add :bib_number, :integer, null: false
      add :finish_status, :string, null: false
      add :external_contact_id, :string, null: false
      add :external_result_id, :string, null: false
      add :uuid, :uuid, null: false
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:participants, [:event_id])
    create unique_index(:participants, [:event_id, :external_contact_id])
  end
end
