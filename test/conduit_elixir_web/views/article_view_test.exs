defmodule ConduitElixirWeb.ArticleViewTest do
  use ConduitElixirWeb.ConnCase, async: true

  import Phoenix.View
  import ConduitElixir.ArticleFixtures

  alias ConduitElixirWeb.ArticleView
  alias ConduitElixir.Auth

  setup do
    {:ok, current_user} =
      Auth.register_user(%{
        email: "test@test.com",
        username: "test_user",
        password: "abcd1234"
      })

    %{
      current_user: current_user
    }
  end

  test "Renders an article favorited by someone other than current user", context do
    %ConduitElixir.ArticleFixtures{articles: articles} = article_fixture()

    # Getting an article favorited by someone other than current_user
    {article, _} =
      articles
      |> List.pop_at(3)

    rendered_article =
      ArticleView.render("article.json", %{article: article, current_user: context.current_user})

    assert rendered_article.favorited == false
    assert rendered_article.favoritesCount == 1
  end
end
