defmodule Lessthanseventy.FoodTrucksTest do
  use Lessthanseventy.DataCase

  alias Lessthanseventy.FoodTrucks

  describe "food_trucks" do
    alias Lessthanseventy.FoodTrucks.FoodTruck

    import Lessthanseventy.FoodTrucksFixtures

    @invalid_attrs %{address: nil, food_items: nil, lat: nil, lon: nil, schedule: nil}

    test "list_food_trucks/0 returns all food_trucks" do
      food_truck = food_truck_fixture()
      assert FoodTrucks.list_food_trucks() == [food_truck]
    end

    test "get_food_truck!/1 returns the food_truck with given id" do
      food_truck = food_truck_fixture()
      assert FoodTrucks.get_food_truck!(food_truck.id) == food_truck
    end

    test "create_food_truck/1 with valid data creates a food_truck" do
      valid_attrs = %{
        name: "some name",
        address: "some address",
        food_items: ["some", "food_items"],
        lat: 120.5,
        lon: 120.5,
        schedule: "some schedule"
      }

      assert {:ok, %FoodTruck{} = food_truck} = FoodTrucks.create_food_truck(valid_attrs)
      assert food_truck.address == "some address"
      assert food_truck.food_items == ["some", "food_items"]
      assert food_truck.lat == 120.5
      assert food_truck.lon == 120.5
      assert food_truck.schedule == "some schedule"
    end

    test "create_food_truck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FoodTrucks.create_food_truck(@invalid_attrs)
    end

    test "update_food_truck/2 with valid data updates the food_truck" do
      food_truck = food_truck_fixture()

      update_attrs = %{
        name: "some updated name",
        address: "some updated address",
        food_items: ["some", "updated", "food_items"],
        lat: 456.7,
        lon: 456.7,
        schedule: "some updated schedule"
      }

      assert {:ok, %FoodTruck{} = food_truck} =
               FoodTrucks.update_food_truck(food_truck, update_attrs)

      assert food_truck.address == "some updated address"
      assert food_truck.food_items == ["some", "updated", "food_items"]
      assert food_truck.lat == 456.7
      assert food_truck.lon == 456.7
      assert food_truck.schedule == "some updated schedule"
    end

    test "update_food_truck/2 with invalid data returns error changeset" do
      food_truck = food_truck_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FoodTrucks.update_food_truck(food_truck, @invalid_attrs)

      assert food_truck == FoodTrucks.get_food_truck!(food_truck.id)
    end
  end
end
