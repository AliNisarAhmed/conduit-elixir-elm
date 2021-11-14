defmodule ConduitElixirWeb.CommentView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      createdAt: comment.inserted_at |> DateTime.to_iso8601(:extended, 0),
      updatedAt: comment.updated_at |> DateTime.to_iso8601(:extended, 0),
      author: comment.user_id
    }
  end
end
