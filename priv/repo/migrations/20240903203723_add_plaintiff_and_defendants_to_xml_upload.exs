defmodule Lessthanseventy.Repo.Migrations.AddPlaintiffAndDefendantsToXmlUpload do
  use Ecto.Migration

  def change do
    alter table(:xml_uploads) do
      add :plaintiff, :text
      add :defendants, :text
    end
  end
end
