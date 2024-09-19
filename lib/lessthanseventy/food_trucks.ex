defmodule Lessthanseventy.FoodTrucks do
  @moduledoc """
  The FoodTrucks context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Lessthanseventy.Repo

  alias Lessthanseventy.FoodTrucks.FoodTruck

  @doc """
  Returns the list of food_trucks.

  ## Examples

      iex> list_food_trucks()
      [%FoodTruck{}, ...]

  """
  def list_food_trucks do
    Repo.all(FoodTruck)
  end

  @doc """
  Gets a single food_truck.

  Raises `Ecto.NoResultsError` if the Food truck does not exist.

  ## Examples

      iex> get_food_truck!(123)
      %FoodTruck{}

      iex> get_food_truck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_truck!(id), do: Repo.get!(FoodTruck, id)

  @doc """
  Creates a food_truck.

  ## Examples

      iex> create_food_truck(%{field: value})
      {:ok, %FoodTruck{}}

      iex> create_food_truck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_food_truck(attrs \\ %{}) do
    %FoodTruck{}
    |> FoodTruck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a food_truck.

  ## Examples

      iex> update_food_truck(food_truck, %{field: new_value})
      {:ok, %FoodTruck{}}

      iex> update_food_truck(food_truck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_truck(%FoodTruck{} = food_truck, attrs) do
    food_truck
    |> FoodTruck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_truck.

  ## Examples

      iex> delete_food_truck(food_truck)
      {:ok, %FoodTruck{}}

      iex> delete_food_truck(food_truck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_food_truck(%FoodTruck{} = food_truck) do
    Repo.delete(food_truck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_truck changes.

  ## Examples

      iex> change_food_truck(food_truck)
      %Ecto.Changeset{data: %FoodTruck{}}

  """
  def change_food_truck(%FoodTruck{} = food_truck, attrs \\ %{}) do
    FoodTruck.changeset(food_truck, attrs)
  end

  def load_and_insert_food_trucks do
    csv =
      download_csv()
      |> parse_csv()

    case insert_all(csv) do
      {:ok, _results} -> list_food_trucks()
      {:error, _failed_operation, failed_value, _changes_so_far} -> {:error, failed_value}
    end
  end

  defp insert_all(food_trucks_data) do
    multi =
      food_trucks_data
      |> Enum.with_index()
      |> Enum.reduce(Multi.new(), fn {food_truck_data, index}, multi ->
        Multi.insert(
          multi,
          {:food_truck, index},
          %FoodTruck{} |> FoodTruck.changeset(food_truck_data)
        )
      end)

    Repo.transaction(multi)
  end

  defp download_csv do
    url = "https://data.sfgov.org/api/views/rqzj-sfat/rows.csv"
    {:ok, response} = HTTPoison.get(url)
    response.body
  end

  defp parse_csv(csv_data) do
    NimbleCSV.RFC4180.parse_string(csv_data)
    |> Enum.map(fn row ->
      [
        _locationid,
        applicant,
        type,
        _cnn,
        location_description,
        address,
        _blocklot,
        _block,
        _lot,
        _permit,
        _status,
        food_items,
        _x,
        _y,
        lat,
        lon,
        schedule | _
      ] =
        row

      food_items = String.split(food_items, ":") |> Enum.map(&String.trim/1)

      %{
        name: applicant,
        type: type,
        location_description: location_description,
        address: address,
        food_items: food_items,
        lat: lat,
        lon: lon,
        schedule: schedule
      }
    end)
  end
end
