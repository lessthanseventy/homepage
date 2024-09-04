defmodule Lessthanseventy.XMLFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lessthanseventy.XML` context.
  """

  @doc """
  Generate a xml_upload.
  """
  def xml_upload_fixture(attrs \\ %{}) do
    {:ok, xml_upload} =
      attrs
      |> Enum.into(%{
        content: "some content",
        plaintiff: "some plaintiff",
        defendants: "some defendants"
      })
      |> Lessthanseventy.XML.create_xml_upload()

    xml_upload
  end
end
