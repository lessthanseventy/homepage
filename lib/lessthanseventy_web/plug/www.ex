defmodule LessthanseventyWeb.Plug.WWW do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case conn.host do
      "www.lessthanseventy.com" ->
        conn
        |> put_resp_header("location", "https://lessthanseventy.com#{conn.request_path}")
        |> send_resp(301, "moved permanently")
        |> halt()

      _ ->
        if Enum.any?(conn.req_headers, fn {key, value} ->
             key == "x-forwarded-proto" and value != "https"
           end) do
          conn
          |> put_resp_header("location", "https://#{conn.host}#{conn.request_path}")
          |> send_resp(301, "moved permanently")
          |> halt()
        else
          conn
        end
    end
  end
end
