defmodule LessthanseventyWeb.FoodTruckLive.Index do
  use LessthanseventyWeb, :live_view

  alias Lessthanseventy.FoodTrucks
  alias Lessthanseventy.FoodTrucks.FoodTruck
  alias LessthanseventyWeb.FoodTruckLive.SearchFormLiveComponent

  @impl true
  def mount(_params, _session, socket) do
    food_trucks = FoodTrucks.list_food_trucks() |> Enum.to_list()
    {:ok, socket |> assign(%{food_trucks: food_trucks, filtered_food_trucks: food_trucks})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "San Francisco Food Truck Search")
    |> assign(:food_truck, nil)
  end

  @impl true
  def handle_event("refresh", _, socket) do
    food_trucks =
      FoodTrucks.load_and_insert_food_trucks()

    {:noreply, socket |> assign(:food_trucks, food_trucks)}
  end

  @impl true
  def handle_info({SearchFormLiveComponent, {:filtered, []}}, socket) do
    {:noreply, socket |> assign(:food_trucks, FoodTrucks.list_food_trucks())}
  end

  def handle_info({SearchFormLiveComponent, {:filtered, filtered_food_trucks}}, socket) do
    socket = socket |> assign(:filtered_food_trucks, filtered_food_trucks)

    {:noreply,
     socket
     |> Phoenix.LiveView.push_event("centerMapOnFirstFoodTruck", %{
       filtered_food_trucks: filtered_food_trucks
     })}
  end
end
