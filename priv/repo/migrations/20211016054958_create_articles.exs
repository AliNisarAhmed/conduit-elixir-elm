defmodule ConduitElixir.Repo.Migrations.CreateArticles do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :string, null: false
      add :description, :string

      timestamps(@timestamps_opts)
    end
  end
end
