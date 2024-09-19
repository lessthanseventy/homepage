defmodule LessthanseventyWeb.Live.FoodTruckLive.ShowTest do
  use LessthanseventyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Lessthanseventy.FoodTrucksFixtures

  defp create_food_truck(_) do
    food_truck = food_truck_fixture()
    %{food_truck: food_truck}
  end

  setup [:create_food_truck]

  test "displays food_truck", %{conn: conn, food_truck: food_truck} do
    {:ok, _show_live, html} = live(conn, ~p"/food_trucks/#{food_truck}")

    assert html =~ food_truck.address
  end
end
