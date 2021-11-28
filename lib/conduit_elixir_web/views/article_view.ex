defmodule ConduitElixirWeb.ArticleView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.ArticleView
  alias ConduitElixirWeb.TagView

  def render("index.json", %{paged_articles: paged_articles, current_user: current_user}) do
    %{
      articles:
        render_many(paged_articles.entries, ArticleView, "article.json", %{
          current_user: current_user
        }),
      articlesCount: paged_articles.total_entries,
      page_number: paged_articles.page_number,
      page_size: paged_articles.page_size,
      total_pages: paged_articles.total_pages
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
      favorited: favorited?(article.article_favorites, current_user),
      favoritesCount: length(article.article_favorites)
    }
  end

  # -------------------------------

  defp favorited?(nil, _), do: false
  defp favorited?(_, nil), do: false
  defp favorited?([], _), do: false
  defp favorited?(_, {:error, _}), do: false

  defp favorited?(list, current_user) do
    list
    |> Enum.any?(fn item -> item.user_id == current_user.id end)
  end
end
