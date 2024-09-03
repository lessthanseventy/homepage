defmodule LessthanseventyWeb.XMLUploadJSON do
  alias Lessthanseventy.XML.XMLUpload

  @doc """
  Renders a list of xml_uploads.
  """
  def index(%{xml_uploads: xml_uploads}) do
    %{data: for(xml_upload <- xml_uploads, do: data(xml_upload))}
  end

  @doc """
  Renders a single xml_upload.
  """
  def show(%{xml_upload: xml_upload}) do
    %{data: data(xml_upload)}
  end

  defp data(%XMLUpload{} = xml_upload) do
    %{
      id: xml_upload.id,
      content: xml_upload.content
    }
  end
end
