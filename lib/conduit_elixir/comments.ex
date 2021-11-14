defmodule ConduitElixir.Comments do
  import Ecto.Query, warn: false
  alias ConduitElixir.Repo

  alias ConduitElixir.Articles
  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Comments.ArticleComment

  def create_comment_on_article(slug, comment_params, current_user) do
    with article <- Articles.get_article(slug) do
      %ArticleComment{}
      |> ArticleComment.create_changeset(article.id, comment_params, current_user)
      |> Repo.insert()
    end
  end

  def get_all_comments_on_article(slug) do
    with %Article{id: id} <- Articles.get_article(slug) do
      query =
        from c in ArticleComment,
          where: c.article_id == ^id,
          order_by: [desc: c.inserted_at]

      Repo.all(query)
    end
  end
end
