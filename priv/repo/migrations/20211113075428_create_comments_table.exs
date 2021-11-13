defmodule ConduitElixir.Repo.Migrations.CreateCommentsTable do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  def change do
    create table(:article_comments) do 
      add :body, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps(@timestamps_opts)
    end
  end
end
