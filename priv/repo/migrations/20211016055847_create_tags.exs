defmodule ConduitElixir.Repo.Migrations.AddTagsTable do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  def change do
    create table(:tags) do 
      add :title, :string, size: 20, null: false  

      timestamps(@timestamps_opts)
    end

    create unique_index("tags", [:title])

    create table(:article_tags) do 
      add :tag_id, references(:tags) 
      add :article_id, references(:articles)
    end

    create unique_index("article_tags", [:tag_id, :article_id])
  end

end
