defmodule ConduitElixirWeb.ArticleView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.ArticleView
  alias ConduitElixirWeb.TagView

  def render("index.json", %{articles: articles}) do
    %{
      articles: render_many(articles, ArticleView, "article.json"),
      articlesCount: length(articles)
    }
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
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
      favorited: favorited?(article.article_favorites, article.user_id),
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
