defmodule ConduitElixirWeb.ArticleView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.ArticleView
  alias ConduitElixirWeb.TagView

  def render("index.json", %{articles: articles, current_user: current_user}) do
    %{
      articles: render_many(articles, ArticleView, "article.json", %{current_user: current_user}),
      articlesCount: length(articles)
    }
  end

  def render("show.json", %{article: article, current_user: current_user}) do
    %{article: render_one(article, ArticleView, "article.json", %{current_user: current_user})}
  end

  def render("article.json", %{article: article, current_user: current_user}) do
    %{
      id: article.id,
      title: article.title,
      body: article.body,
      description: article.description,
      updatedAt: article.updated_at |> DateTime.to_iso8601(:extended, 0),
      createdAt: article.inserted_at |> DateTime.to_iso8601(:extended, 0),
      tagList: TagView.render("index.json", tags: article.tags),
      author: article.user_id,
      slug: article.slug,
      favorited: favorited?(article.article_favorites, current_user.id),
      favoritesCount: length(article.article_favorites)
    }
  end

  # -------------------------------

  defp favorited?(nil, _), do: false
  defp favorited?([], _), do: false
  defp favorited?(list, user_id) do
    list
    |> Enum.any?(fn item -> item.user_id == user_id end)
  end
end
