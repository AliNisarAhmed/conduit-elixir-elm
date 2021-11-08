defmodule ConduitElixirWeb.ArticleController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Articles
  alias ConduitElixir.Articles.Article

  import ConduitElixirWeb.Plugs.Auth

  action_fallback ConduitElixirWeb.FallbackController

  plug :require_authenticated_user when action in [:create, :favorite]

  def index(conn, %{ "author" => author }) do 
    articles = Articles.list_articles_by_author(author)
    render(conn, "index.json", articles: articles)
  end

  def index(conn, _params) do
    articles = Articles.list_articles()
    IO.inspect(articles)
    render(conn, "index.json", articles: articles)
  end

  def create(%Plug.Conn{assigns: assigns} = conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <-
           Articles.create_article(article_params, assigns.current_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"slug" => slug}) do
    article = Articles.get_article!(slug)
    render(conn, "show.json", article: article)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{} = article} <- Articles.update_article(article, article_params) do
      render(conn, "show.json", article: article)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{}} <- Articles.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end

  # -------- Favorite -------------

  def favorite(conn, %{"slug" => slug}) do
    with {:ok, article} <- Articles.favorite_article(conn.assigns.current_user.id, slug) do
      render(conn, "show.json", article: article)
    end
  end

  def unfavorite(conn, %{"slug" => slug}) do
    with {:ok, article} <- Articles.unfavorite_article(conn.assigns.current_user.id, slug) do
      render(conn, "show.json", article: article)
    end
  end
end
