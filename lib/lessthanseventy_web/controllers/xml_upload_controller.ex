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
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    xml_content = Jason.decode!(body)
    {plaintiff, defendants} = XML.parse(body)

    try do
      with {:ok, %XMLUpload{} = xml_upload} <-
             XML.create_xml_upload(%{
               content: xml_content,
               plaintiff: plaintiff,
               defendants: defendants
             }) do
        response_body =
          %{"message" => "XML data processed successfully", "id" => xml_upload.id}
          |> Jason.encode!()

        conn
        |> put_status(:created)
        |> put_resp_content_type("application/json")
        |> put_resp_header("location", ~p"/api/xml_uploads/#{xml_upload}")
        |> send_resp(201, response_body)
      end
    rescue
      e in Plug.Parsers.ParseError ->
        raise e
    end
  end

  def show(conn, %{"id" => id}) do
    {:ok, xml_upload} = XML.get_xml_upload(id)
    render(conn, :show, xml_upload: xml_upload)
  end

  def update(conn, %{"id" => id, "xml_upload" => xml_upload_params}) do
    {:ok, xml_upload} = XML.get_xml_upload(id)

    with {:ok, %XMLUpload{} = xml_upload} <- XML.update_xml_upload(xml_upload, xml_upload_params) do
      render(conn, :show, xml_upload: xml_upload)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, xml_upload} = XML.get_xml_upload(id)

    with {:ok, %XMLUpload{}} <- XML.delete_xml_upload(xml_upload) do
      send_resp(conn, :no_content, "")
    end
  end
end
