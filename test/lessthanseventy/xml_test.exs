defmodule Lessthanseventy.XMLTest do
  use Lessthanseventy.DataCase

  alias Lessthanseventy.XML

  describe "xml_uploads" do
    alias Lessthanseventy.XML.XMLUpload

    import Lessthanseventy.XMLFixtures

    @invalid_attrs %{content: nil}

    test "list_xml_uploads/0 returns all xml_uploads" do
      xml_upload = xml_upload_fixture()
      assert XML.list_xml_uploads() == [xml_upload]
    end

    test "get_xml_upload!/1 returns the xml_upload with given id" do
      xml_upload = xml_upload_fixture()
      assert XML.get_xml_upload!(xml_upload.id) == xml_upload
    end

    test "create_xml_upload/1 with valid data creates a xml_upload" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %XMLUpload{} = xml_upload} = XML.create_xml_upload(valid_attrs)
      assert xml_upload.content == "some content"
    end

    test "create_xml_upload/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = XML.create_xml_upload(@invalid_attrs)
    end

    test "update_xml_upload/2 with valid data updates the xml_upload" do
      xml_upload = xml_upload_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %XMLUpload{} = xml_upload} = XML.update_xml_upload(xml_upload, update_attrs)
      assert xml_upload.content == "some updated content"
    end

    test "update_xml_upload/2 with invalid data returns error changeset" do
      xml_upload = xml_upload_fixture()
      assert {:error, %Ecto.Changeset{}} = XML.update_xml_upload(xml_upload, @invalid_attrs)
      assert xml_upload == XML.get_xml_upload!(xml_upload.id)
    end

    test "delete_xml_upload/1 deletes the xml_upload" do
      xml_upload = xml_upload_fixture()
      assert {:ok, %XMLUpload{}} = XML.delete_xml_upload(xml_upload)
      assert_raise Ecto.NoResultsError, fn -> XML.get_xml_upload!(xml_upload.id) end
    end

    test "change_xml_upload/1 returns a xml_upload changeset" do
      xml_upload = xml_upload_fixture()
      assert %Ecto.Changeset{} = XML.change_xml_upload(xml_upload)
    end
  end
end
