defmodule ConduitElixirWeb.ArticleControllerTest do
  use ConduitElixirWeb.ConnCase, async: true

  import ConduitElixir.ArticleFixtures

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Auth

  @create_attrs %{
    body: "some body",
    description: "some description",
    title: "some title"
  }
  @update_attrs %{
    body: "some updated body",
    description: "some updated description"
  }
  @invalid_attrs %{body: nil, description: nil, title: nil}

  # describe "index" do
  #   test "lists all articles", %{conn: conn} do
  #     conn = get(conn, Routes.article_path(conn, :index))
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create article" do
    setup [:setup_fixture, :login_user_1]

    test "renders article when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs)
      assert %{"article" => article} = json_response(conn, 201)

      conn = get(conn, Routes.article_path(conn, :show, article["slug"]))

      assert %{
               "body" => "some body",
               "description" => "some description",
               "title" => "some title",
               "slug" => "some-title"
             } = json_response(conn, 200)["article"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "Update Article - when the owner is logged in" do
    setup [:setup_fixture, :login_user_1]

    test "renders article when data is valid", %{
      conn: conn,
      current_user_1: current_user_1,
      current_user_2: current_user_2,
      articles: articles
    } do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = put(conn, Routes.article_path(conn, :update, slug), article: @update_attrs)
      assert %{"article" => article_resp} = json_response(conn, 200)

      conn = get(conn, Routes.article_path(conn, :show, slug))

      updated_article = json_response(conn, 200)["article"]

      assert updated_article["body"] == article_resp["body"]
      assert updated_article["description"] == article_resp["description"]
      assert updated_article["title"] == article.title
      assert updated_article["slug"] == article.slug
      assert updated_article["body"] != article.body
      assert updated_article["description"] != article.description
    end
  end

  describe "Update Article - when the logged in user is not the owner" do
    setup [:setup_fixture, :login_user_2]

    test "renders error", %{conn: conn, articles: articles} do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = put(conn, Routes.article_path(conn, :update, slug), article: @update_attrs)

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "Delete article - when logged in as owner" do
    setup [:setup_fixture, :login_user_1]

    test "deletes chosen article", %{conn: conn, articles: articles} do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = delete(conn, Routes.article_path(conn, :delete, slug))
      assert response(conn, 204)

      conn = get(conn, Routes.article_path(conn, :show, slug))
      assert json_response(conn, 404)["errors"] != %{}
    end
  end

  describe "Delete article - when logged is as non-owner" do
    setup [:setup_fixture, :login_user_2]

    test "responds with an error", %{conn: conn, articles: articles} do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = delete(conn, Routes.article_path(conn, :delete, slug))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  # -----------------------------------------
  defp setup_fixture(%{conn: conn}) do
    %{
      current_user_1: current_user_1,
      current_user_2: current_user_2,
      articles: articles
    } = article_fixture()

    conn = conn |> put_req_header("accept", "application/json")

    {:ok,
     conn: conn,
     articles: articles,
     current_user_1: current_user_1,
     current_user_2: current_user_2}
  end

  defp login_user(conn, user) do
    token = Auth.get_token(user)

    conn =
      conn
      |> put_req_header("authorization", "Token #{token}")

    {:ok, conn: conn}
  end

  defp login_user_1(%{conn: conn, current_user_1: current_user_1}) do
    login_user(conn, current_user_1)
  end

  defp login_user_2(%{conn: conn, current_user_2: current_user_2}) do
    login_user(conn, current_user_2)
  end
end
