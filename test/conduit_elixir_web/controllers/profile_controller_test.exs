defmodule ConduitElixirWeb.ProfileControllerTest do
  use ConduitElixirWeb.ConnCase, async: true

  import ConduitElixir.ArticleFixtures

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Auth

  describe "GET profile route" do
    setup [:setup_fixture, :login_user_1]

    test "fetches profile for a user", %{
      conn: conn,
      current_user_1: current_user_1,
      current_user_2: current_user_2
    } do
      conn = get(conn, Routes.profile_path(conn, :show, current_user_2.username))

      profile = json_response(conn, 200)["profile"]

      assert profile != nil
      assert profile != %{}

      assert profile["username"] == current_user_2.username
      assert profile["bio"] == current_user_2.bio
      assert profile["following"] == false
    end
  end

  describe "GET profile route - unauthorized request" do
    setup [:setup_fixture]

    test "returns 401 unauthorized", %{conn: conn, current_user_2: current_user_2} do
      conn = get(conn, Routes.profile_path(conn, :show, current_user_2.username))

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "POST - follow user; DELETE - unfollow user" do
    setup [:setup_fixture, :login_user_1]

    test "User can follow other user, represented by \"following\" property", %{
      conn: conn,
      current_user_1: current_user_1,
      current_user_2: current_user_2
    } do
      conn = get(conn, Routes.profile_path(conn, :show, current_user_2.username))

      profile = json_response(conn, 200)["profile"]

      assert profile["username"] == current_user_2.username
      assert profile["following"] == false

      conn = post(conn, Routes.profile_path(conn, :follow_user, current_user_2.username))

      profile = json_response(conn, 200)["profile"]

      assert profile["username"] == current_user_2.username
      assert profile["following"] == true

      conn = delete(conn, Routes.profile_path(conn, :unfollow_user, current_user_2.username))

      profile = json_response(conn, 200)["profile"]

      assert profile["username"] == current_user_2.username
      assert profile["following"] == false
    end

  end

  # -----------------------------------------------------

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
