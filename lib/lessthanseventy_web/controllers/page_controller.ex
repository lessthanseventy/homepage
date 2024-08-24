defmodule LessthanseventyWeb.PageController do
  use LessthanseventyWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
