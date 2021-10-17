defmodule ConduitElixir.Repo.Migrations.AddTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do 
      add :title, :string, size: 20, null: false  

      timestamps()
    end

    create unique_index("tags", [:title])

    create table(:article_tags) do 
      add :tag_id, references(:tags) 
      add :article_id, references(:articles)
    end

    create unique_index("article_tags", [:tag_id, :article_id])
  end

end
