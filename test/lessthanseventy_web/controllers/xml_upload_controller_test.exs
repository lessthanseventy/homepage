defmodule LessthanseventyWeb.XMLUploadControllerTest do
  use LessthanseventyWeb.ConnCase

  import Lessthanseventy.XMLFixtures

  alias Lessthanseventy.XML.XMLUpload

  @create_attrs %{
    content: "some content"
  }
  @update_attrs %{
    content: "some updated content"
  }
  @invalid_attrs %{content: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all xml_uploads", %{conn: conn} do
      conn = get(conn, ~p"/api/xml_uploads")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create xml_upload" do
    test "renders xml_upload when data is valid", %{conn: conn} do
      request_body = @create_attrs |> Jason.encode!()

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(~p"/api/xml_uploads", request_body)

      assert %{"id" => id, "message" => "XML data processed successfully"} =
               json_response(conn, 201)

      conn = get(conn, ~p"/api/xml_uploads/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some content"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      request_body = @invalid_attrs |> Jason.encode!()

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post(~p"/api/xml_uploads", request_body)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update xml_upload" do
    setup [:create_xml_upload]

    test "renders xml_upload when data is valid", %{
      conn: conn,
      xml_upload: %XMLUpload{id: id} = xml_upload
    } do
      conn = put(conn, ~p"/api/xml_uploads/#{xml_upload}", xml_upload: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/xml_uploads/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some updated content"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, xml_upload: xml_upload} do
      conn = put(conn, ~p"/api/xml_uploads/#{xml_upload}", xml_upload: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete xml_upload" do
    setup [:create_xml_upload]

    test "deletes chosen xml_upload", %{conn: conn, xml_upload: xml_upload} do
      conn = delete(conn, ~p"/api/xml_uploads/#{xml_upload}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/xml_uploads/#{xml_upload}")
      end
    end
  end

  defp create_xml_upload(_) do
    xml_upload = xml_upload_fixture()
    %{xml_upload: xml_upload}
  end
end
