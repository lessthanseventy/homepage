defmodule LessthanseventyWeb.FoodTruckLive.MapComponent do
  use LessthanseventyWeb, :live_component

  alias Lessthanseventy.FoodTrucks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full h-full mb-5">
      <div class="flex flex-col items-left justify-center">
        <form phx-debounce="1000" phx-change="filter" phx-target={@myself}>
          <label class="text-retroGreen" for="tag">Filter by tag</label>
          <input class="text-black w-[60%] mb-5" list="tags" name="tag" phx-change="filter" />
          <datalist id="tags">
            <option :for={tag <- @tags} value={tag} />
          </datalist>
        </form>
      </div>
      <div
        class="w-full h-full"
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
       tags: tags,
       suggestions: [],
       filtered_food_trucks: food_trucks
     })}
  end

  @impl true
  def handle_event("filter", %{"tag" => tag}, socket) do
    filtered_food_trucks =
      Enum.filter(socket.assigns.food_trucks, fn truck ->
        Enum.member?(
          Enum.map(truck.food_items, &String.downcase/1),
          String.downcase(tag)
        )
      end)

    notify_parent({:filtered, filtered_food_trucks})

    {:noreply, assign(socket, filtered_food_trucks: filtered_food_trucks)}
  end

  def handle_event("center", %{"address" => address}, socket) do
    {:noreply, push_event(socket, "centerMapOnAddress", %{address: address})}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
