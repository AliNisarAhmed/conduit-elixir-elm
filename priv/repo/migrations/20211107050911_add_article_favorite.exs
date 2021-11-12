defmodule ConduitElixir.Repo.Migrations.AddArticleFavorite do
  use Ecto.Migration

  def change do
    create table(:article_favorites) do 
      add :article_id, references(:articles, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create unique_index("article_favorites", [:article_id, :user_id])
  end
end
