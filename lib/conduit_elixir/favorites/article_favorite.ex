defmodule ConduitElixir.Favorites.ArticleFavorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Auth.User
  alias ConduitElixir.Articles.Article

  schema "article_favorites" do
    belongs_to :article, Article
    belongs_to :user, User 
  end

  @doc false
  def changeset(articleFavorite, attrs) do
    articleFavorite
    |> cast(attrs, [:article_id, :user_id])
    |> validate_required([:article_id, :user_id])
    |> unique_constraint([:article_id, :user_id])
  end
end
