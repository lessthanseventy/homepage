defmodule Lessthanseventy.FoodTrucksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lessthanseventy.FoodTrucks` context.
  """

  @doc """
  Generate a food_truck.
  """
  def food_truck_fixture(attrs \\ %{}) do
    {:ok, food_truck} =
      attrs
      |> Enum.into(%{
        name: "some name",
        address: "some address",
        food_items: ["some", "food_items"],
        lat: 120.5,
        lon: 120.5,
        schedule: "some schedule"
      })
      |> Lessthanseventy.FoodTrucks.create_food_truck()

    food_truck
  end
end
