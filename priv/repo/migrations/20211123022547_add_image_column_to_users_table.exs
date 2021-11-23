defmodule ConduitElixir.Repo.Migrations.AddImageColumnToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :image, :text, null: true
    end
  end
end
