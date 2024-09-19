defmodule LessthanseventyWeb.FoodTruckLive.MapComponent do
  use LessthanseventyWeb, :live_component

  alias Lessthanseventy.FoodTrucks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full h-full">
      <.live_component
        module={LessthanseventyWeb.FoodTruckLive.SearchFormLiveComponent}
        id="map-search"
        food_trucks={@food_trucks}
      />
      <div
        class="w-full h-[90%]"
        id="map-component"
        phx-hook="MapComponent"
        data-food-trucks={Jason.encode!(@filtered_food_trucks)}
      >
      </div>
    </div>
    """
  end

  @impl true
  def update(%{food_trucks: food_trucks} = assigns, socket) do
    tags =
      food_trucks
      |> Enum.flat_map(& &1.food_items)
      |> Enum.map(&String.downcase/1)
      |> Enum.uniq()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(%{
       food_trucks: food_trucks,
       tags: tags
     })}
  end
end
