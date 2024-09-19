defmodule LessthanseventyWeb.Live.FoodTruckLive.IndexTest do
  use LessthanseventyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lessthanseventy.FoodTrucksFixtures

  defp create_food_truck(_) do
    food_truck = food_truck_fixture()
    %{food_truck: food_truck}
  end

  setup [:create_food_truck]

  test "lists all food_trucks", %{conn: conn, food_truck: _food_truck} do
    {:ok, _index_live, html} = live(conn, ~p"/food_trucks")
    assert html =~ "San Francisco Food Truck Search"
  end
end
