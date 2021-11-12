defmodule ConduitElixir.ArticlesTest do
  use ConduitElixir.DataCase

  alias ConduitElixir.Articles
  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Auth

  import ConduitElixir.ArticleFixtures

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

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

  describe "Articles Context - Create Article" do
    test "create_article/1 with valid data creates a article", context do
      valid_attrs =
        attrs = %{
          "body" => "body 1",
          "description" => "description 2",
          "title" => "some title 1",
          "tagList" => []
        }

      assert {:ok, %Article{} = article} =
               Articles.create_article(valid_attrs, context.current_user)

      assert article.body == "body 1"
      assert article.description == "description 2"
      assert article.title == "some title 1"
      assert article.slug == "some-title-1"
      assert article.user_id == context.current_user.id
    end

    test "create_article/1 with invalid data returns error changeset", context do
      invalid_attrs = %{}

      {:error, %Ecto.Changeset{} = changeset} =
        Articles.create_article(invalid_attrs, context.current_user)
    end
  end

  describe "Articles Context - List Articles" do
    test "list_articles/0 returns all articles" do
      %{articles: articles} = article_fixture()

      assert length(Articles.list_articles()) == length(articles)
    end

    test "list_articles_by_author/1 returns articles only by that author" do
      %{articles: articles} = article_fixture()

      author_1 = "test_user_1"

      assert length(Articles.list_articles_by_author(author_1)) ==
               length(Enum.filter(articles, fn art -> art.user.username == author_1 end))

      author_2 = "test_user_2"

      assert length(Articles.list_articles_by_author(author_2)) ==
               length(Enum.filter(articles, fn art -> art.user.username == author_2 end))

      author_3 = "does_not_exist"

      assert length(Articles.list_articles_by_author(author_3)) == 0
    end
  end

  describe "Articles Context - Favorite & Unfavorite" do
    test "User can favorite an article", context do
      %{articles: articles} = article_fixture()
      slug = "some-title-1"

      assert {:ok, %Article{} = article} =
               Articles.favorite_article(context.current_user.id, slug)

      assert article.slug == slug
      assert article.title == "some title 1"
      assert length(article.article_favorites) == 1

      assert Enum.any?(article.article_favorites, fn af ->
               af.user_id == context.current_user.id
             end) == true
    end

    test "User can unfavorite an article", context do
      %{articles: articles} = article_fixture()
      slug = "some-title-4"

      Articles.favorite_article(context.current_user.id, slug)

      assert {:ok, %Article{} = article} =
               Articles.unfavorite_article(context.current_user.id, slug)

      assert article.slug == slug
      assert article.title == "some title 4"

      assert Enum.any?(article.article_favorites, fn af ->
               af.user_id == context.current_user.id
             end) == false
    end
  end

  # describe "articles" do
  #   alias ConduitElixir.Articles.Article

  #   import ConduitElixir.ArticlesFixtures

  #   @invalid_attrs %{body: nil, description: nil, title: nil}

  #   test "list_articles/0 returns all articles" do
  #     article = article_fixture()
  #     assert Articles.list_articles() == [article]
  #   end

  #   test "get_article!/1 returns the article with given id" do
  #     article = article_fixture()
  #     assert Articles.get_article!(article.id) == article
  #   end

  #   test "create_article/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs)
  #   end

  #   test "update_article/2 with valid data updates the article" do
  #     article = article_fixture()
  #     update_attrs = %{body: "some updated body", description: "some updated description", title: "some updated title"}

  #     assert {:ok, %Article{} = article} = Articles.update_article(article, update_attrs)
  #     assert article.body == "some updated body"
  #     assert article.description == "some updated description"
  #     assert article.title == "some updated title"
  #   end

  #   test "update_article/2 with invalid data returns error changeset" do
  #     article = article_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
  #     assert article == Articles.get_article!(article.id)
  #   end

  #   test "delete_article/1 deletes the article" do
  #     article = article_fixture()
  #     assert {:ok, %Article{}} = Articles.delete_article(article)
  #     assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
  #   end

  #   test "change_article/1 returns a article changeset" do
  #     article = article_fixture()
  #     assert %Ecto.Changeset{} = Articles.change_article(article)
  #   end
  # end
end
