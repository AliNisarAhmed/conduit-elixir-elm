defmodule ConduitElixirWeb.ArticleView do
  use ConduitElixirWeb, :view
  alias ConduitElixirWeb.ArticleView

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
    %{id: article.id, title: article.title}
  end
end
