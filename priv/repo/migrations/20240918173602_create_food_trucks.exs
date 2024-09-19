defmodule Lessthanseventy.Repo.Migrations.CreateFoodTrucks do
  use Ecto.Migration

  def change do
    create table(:food_trucks) do
      add :name, :string, size: 500
      add :type, :string
      add :location_description, :string
      add :address, :string
      add :food_items, {:array, :string}
      add :lat, :float
      add :lon, :float
      add :schedule, :string

      timestamps(type: :utc_datetime)
    end
  end
end
