defmodule LessthanseventyWeb.XMLUploadController do
  use LessthanseventyWeb, :controller

  alias Lessthanseventy.XML
  alias Lessthanseventy.XML.XMLUpload

  action_fallback LessthanseventyWeb.FallbackController

  def index(conn, _params) do
    xml_uploads = XML.list_xml_uploads()
    render(conn, :index, xml_uploads: xml_uploads)
  end

  def create(conn, _params) do
    {:ok, xml_content, conn} = Plug.Conn.read_body(conn)

    {plaintiff, defendants} = XML.parse(xml_content)

    case XML.create_xml_upload(%{
           content: xml_content,
           plaintiff: plaintiff,
           defendants: defendants
         }) do
      {:ok, %XMLUpload{} = xml_upload} ->
        response_body =
          %{"message" => "XML data processed successfully", "id" => xml_upload.id}
          |> Jason.encode!()

        conn
        |> put_status(:created)
        |> put_resp_content_type("application/json")
        |> put_resp_header("location", ~p"/api/xml_uploads/#{xml_upload}")
        |> send_resp(201, response_body)

      {:error, %Ecto.Changeset{}} ->
        response_body = %{"errors" => "invalid data"} |> Jason.encode!()

        conn
        |> put_status(:unprocessable_entity)
        |> put_resp_content_type("application/json")
        |> send_resp(422, response_body)

      {:error, reason} ->
        response_body = %{"errors" => reason} |> Jason.encode!()

        conn
        |> put_status(:unprocessable_entity)
        |> put_resp_content_type("application/json")
        |> send_resp(422, response_body)
    end
  end

  def show(conn, %{"id" => id}) do
    xml_upload = XML.get_xml_upload!(id)
    render(conn, :show, xml_upload: xml_upload)
  end

  def delete(conn, %{"id" => id}) do
    xml_upload = XML.get_xml_upload!(id)

    with {:ok, %XMLUpload{}} <- XML.delete_xml_upload(xml_upload) do
      send_resp(conn, :no_content, "")
    end
  end
end
