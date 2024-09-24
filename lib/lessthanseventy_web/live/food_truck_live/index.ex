defmodule LessthanseventyWeb.FoodTruckLive.Index do
  use LessthanseventyWeb, :live_view

  alias Lessthanseventy.FoodTrucks
  alias LessthanseventyWeb.FoodTruckLive.SearchFormLiveComponent

  @impl true
  def mount(params, _url, %{} = socket) do
    case connected?(socket) do
      true ->
        food_trucks = FoodTrucks.list_food_trucks() |> Enum.to_list()
        selected_food_truck = params["selected_food_truck"]

        {:ok,
         assign(socket,
           food_trucks: food_trucks,
           filtered_food_trucks: food_trucks,
           selected_food_truck: selected_food_truck
         )}

      false ->
        {:ok, assign(socket, food_trucks: [], filtered_food_trucks: [], selected_food_truck: nil)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    socket
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
