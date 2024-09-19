defmodule LessthanseventyWeb.FoodTruckLive.SearchFormLiveComponent do
  use LessthanseventyWeb, :live_component

  def update(assigns, socket) do
    socket =
      socket
      |> assign(%{
        search_results: [],
        search_phrase: ""
      })
      |> assign(assigns)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-left justify-center">
      <form phx-debounce="1000" phx-submit="filter" phx-change="filter" phx-target={@myself}>
        <input
          type="text"
          class="form-control"
          name="search_phrase"
          value={@search_phrase}
          phx-debounce="500"
          placeholder="Search by tag..."
        />

        <%= if @search_results != [] do %>
          <div class="relative">
            <div class="absolute dropdown-results left-[4rem] right-0 rounded border border-gray-100 shadow py-2 bg-white w-[65%] max-h-96 overflow-hidden">
              <%= for search_result <- @search_results do %>
                <div
                  class="cursor-pointer h-7 m-2 hover:bg-gray-200 focus:bg-gray-200"
                  phx-click="pick"
                  phx-target={@myself}
                  phx-value-name={search_result}
                  tabindex="0"
                >
                  <%= raw(format_search_result(search_result, @search_phrase)) %>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>

        <p class="pt-1 text-xs text-gray-700">Search for states</p>
      </form>
    </div>
    """
  end

  def handle_event("filter", %{"search_phrase" => ""}, socket) do
    assigns = [
      search_results: [],
      search_phrase: ""
    ]

    notify_parent({:filtered, socket.assigns.food_trucks})

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("filter", %{"search_phrase" => search_phrase}, socket) do
    assigns = [
      search_results: search(socket.assigns.food_trucks, search_phrase),
      search_phrase: search_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick", %{"name" => search_phrase}, socket) do
    filtered_food_trucks =
      Enum.filter(socket.assigns.food_trucks, fn truck ->
        Enum.member?(
          Enum.map(truck.food_items, &String.downcase/1),
          String.downcase(search_phrase)
        )
      end)

    assigns = [
      search_results: [],
      search_phrase: search_phrase
    ]

    notify_parent({:filtered, filtered_food_trucks})
    {:noreply, assign(socket, assigns)}
  end

  def search(""), do: []

  def search(food_trucks, search_phrase) do
    food_trucks
    |> Enum.flat_map(& &1.food_items)
    |> Enum.map(&String.downcase/1)
    |> Enum.uniq()
    |> Enum.filter(&matches?(&1, search_phrase))
  end

  def matches?(first, second) do
    String.starts_with?(
      String.downcase(first),
      String.downcase(second)
    )
  end

  def format_search_result(search_result, search_phrase) do
    split_at = String.length(search_phrase)
    {selected, rest} = String.split_at(search_result, split_at)

    "<strong>#{selected}</strong>#{rest}"
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
