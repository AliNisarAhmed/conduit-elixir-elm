defmodule ConduitElixir.CommentFixtures do
  defstruct [:current_user_1, :current_user_2, :current_user_3, articles: [], comments: []]

  alias ConduitElixir.Comments

  import Ecto.Query, warn: false

  import ConduitElixir.ArticleFixtures

  def comment_fixture() do
    %{
      current_user_1: current_user_1,
      current_user_2: current_user_2,
      current_user_3: current_user_3,
      articles: articles
    } = article_fixture()

    for {index, article} <- Enum.zip(1..4, articles) do
      comment_params = create_comment_attr(index, current_user_1)
      Comments.create_comment_on_article(article.slug, comment_params, current_user_1)

      comment_params = create_comment_attr(index, current_user_2)
      Comments.create_comment_on_article(article.slug, comment_params, current_user_2)
    end

    comments =
      articles
      |> Enum.flat_map(fn article ->
        Comments.get_all_comments_on_article(article.slug)
      end)

    %ConduitElixir.CommentFixtures{
      articles: articles,
      comments: comments,
      current_user_1: current_user_1,
      current_user_2: current_user_2,
      current_user_3: current_user_3
    }
  end

  # ---------------

  defp create_comment_attr(index, current_user) do
    %{body: "Comment #{index} by user #{current_user.username}"}
  end
end
