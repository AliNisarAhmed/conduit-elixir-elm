defmodule ConduitElixirWeb.CommentController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Comments
  alias ConduitElixir.Comments.ArticleComment

  import ConduitElixirWeb.Plugs.Auth

  action_fallback ConduitElixirWeb.FallbackController

  plug :require_authenticated_user when action in [:index, :create]

  def index(%Plug.Conn{} = conn, %{"slug" => slug}) do 
    with comments <- Comments.get_all_comments_on_article(slug) do 
      conn 
      |> put_status(200)
      |> render("index.json", comments: comments)
    end
  end

  def create(%Plug.Conn{assigns: assigns} = conn, %{"slug" => slug, "comment" => comment_params}) do
    with {:ok, %ArticleComment{} = comment} <-
           Comments.create_comment_on_article(slug, comment_params, assigns.current_user) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
