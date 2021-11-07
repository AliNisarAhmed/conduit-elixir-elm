defmodule ConduitElixir.Repo.Migrations.AddArticleFavorite do
  use Ecto.Migration

  def change do
    create table(:article_favorites) do 
      add :article_id, references(:articles)
      add :user_id, references(:users)
    end

    create unique_index("article_favorites", [:article_id, :user_id])
  end
end
