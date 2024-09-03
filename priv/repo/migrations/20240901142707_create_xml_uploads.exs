defmodule Lessthanseventy.Repo.Migrations.CreateXmlUploads do
  use Ecto.Migration

  def change do
    create table(:xml_uploads) do
      add :content, :text

      timestamps(type: :utc_datetime)
    end
  end
end
