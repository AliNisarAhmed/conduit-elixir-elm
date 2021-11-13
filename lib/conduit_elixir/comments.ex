defmodule ConduitElixir.Comments do
  import Ecto.Query, warn: false
  alias ConduitElixir.Repo

  alias ConduitElixir.Articles
  alias ConduitElixir.Comments.ArticleComment

  def create_comment_on_article(slug, comment_params, current_user) do
    with article <- Articles.get_article(slug) do
      %ArticleComment{}
      |> ArticleComment.create_changeset(article.id, comment_params, current_user)
      |> Repo.insert()
    end
  end
end
