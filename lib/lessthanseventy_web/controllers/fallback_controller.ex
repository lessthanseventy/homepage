defmodule LessthanseventyWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use LessthanseventyWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = _changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(html: LessthanseventyWeb.ErrorHTML, json: LessthanseventyWeb.ErrorJSON)
    |> render(:"404")
  end
end
