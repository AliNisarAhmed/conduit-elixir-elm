defmodule ConduitElixirWeb.ArticleController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Articles
  alias ConduitElixir.Articles.Article

  import ConduitElixirWeb.Plugs.Auth

  action_fallback ConduitElixirWeb.FallbackController

  plug :require_authenticated_user when action in [:index, :create, :update, :delete, :favorite]

  def index(%Plug.Conn{assigns: assigns} = conn, %{"author" => author}) do
    with {:ok, articles} <- Articles.list_articles_by_author(author) do
      render(conn, "index.json", articles: articles, current_user: assigns.current_user)
    end
  end

  def index(%Plug.Conn{assigns: assigns} = conn, %{"tag" => tag}) do
    articles = Articles.list_articles_by_tag(tag)
    render(conn, "index.json", articles: articles, current_user: assigns.current_user)
  end

  def index(%Plug.Conn{assigns: assigns} = conn, %{"favorited" => username}) do
    with {:ok, articles} <- Articles.list_articles_favorited_by_username(username) do
      render(conn, "index.json", articles: articles, current_user: assigns.current_user)
    end
  end

  def index(%Plug.Conn{assigns: assigns} = conn, _params) do
    articles = Articles.list_articles()
    render(conn, "index.json", articles: articles, current_user: assigns.current_user)
  end

  def create(%Plug.Conn{assigns: assigns} = conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <-
           Articles.create_article(article_params, assigns.current_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article, current_user: assigns.current_user)
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Articles.get_article(slug) do
      nil ->
        {:error, :not_found}

      article ->
        render(conn, "show.json", article: article)
    end
  end

  def update(%Plug.Conn{assigns: assigns} = conn, %{"slug" => slug, "article" => article_params}) do
    case Articles.get_article(slug) do
      nil ->
        {:error, :not_found}

      article ->
        if article.user_id != assigns.current_user.id do
          {:error, :unauthorized}
        else
          with {:ok, %Article{} = article} <- Articles.update_article(article, article_params) do
            render(conn, "show.json", article: article)
          end
        end
    end
  end

  def delete(%Plug.Conn{assigns: assigns} = conn, %{"slug" => slug}) do
    case Articles.get_article(slug) do
      nil ->
        {:error, :not_found}

      article ->
        if article.user_id != assigns.current_user.id do
          {:error, :unauthorized}
        else
          with {:ok, _} <- Articles.delete_article(article) do
            send_resp(conn, :no_content, "")
          else
            e -> e
          end
        end
    end
  end

  # -------- Favorite -------------

  def favorite(%Plug.Conn{assigns: assigns} = conn, %{"slug" => slug}) do
    with {:ok, article} <- Articles.favorite_article(conn.assigns.current_user.id, slug) do
      render(conn, "show.json", article: article, current_user: assigns.current_user)
    end
  end

  def unfavorite(%Plug.Conn{assigns: assigns} = conn, %{"slug" => slug}) do
    with {:ok, article} <- Articles.unfavorite_article(conn.assigns.current_user.id, slug) do
      render(conn, "show.json", article: article, current_user: assigns.current_user)
    end
  end
end
