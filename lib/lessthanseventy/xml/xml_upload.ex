defmodule Lessthanseventy.XML.XMLUpload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "xml_uploads" do
    field :content, :string
    field :plaintiff, :string
    field :defendants, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(xml_upload, attrs) do
    xml_upload
    |> cast(attrs, [:content, :plaintiff, :defendants])
    |> validate_required([:content, :plaintiff, :defendants])
  end
end
