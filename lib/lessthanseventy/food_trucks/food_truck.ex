defmodule Lessthanseventy.FoodTrucks.FoodTruck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "food_trucks" do
    field :name, :string
    field :type, :string
    field :location_description, :string
    field :address, :string
    field :food_items, {:array, :string}
    field :lat, :float
    field :lon, :float
    field :schedule, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(food_truck, attrs) do
    food_truck
    |> cast(attrs, [
      :name,
      :type,
      :location_description,
      :address,
      :food_items,
      :lat,
      :lon,
      :schedule
    ])
    |> validate_required([:name, :lat, :lon])
  end

  defimpl Jason.Encoder, for: Lessthanseventy.FoodTrucks.FoodTruck do
    def encode(struct, opts) do
      map =
        struct
        |> Map.from_struct()
        |> Map.drop([:__meta__])

      Jason.Encode.map(map, opts)
    end
  end
end
