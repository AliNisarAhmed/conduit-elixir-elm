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
    %{data: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      title: article.title,
      body: article.body,
      description: article.description,
      updatedAt: article.updated_at |> NaiveDateTime.to_iso8601(),
      createdAt: article.inserted_at |> NaiveDateTime.to_iso8601(),
      tagList: TagView.render("index.json", tags: article.tags),
      author: article.user_id
    }
  end
end
