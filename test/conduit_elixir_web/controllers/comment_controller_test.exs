defmodule ConduitElixirWeb.CommentControllerTest do
  use ConduitElixirWeb.ConnCase, async: true

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Auth

  import ConduitElixir.CommentFixtures

  @create_attrs %{
    body: "Comment created in Test"
  }

  @invalid_attrs %{
    body: nil
  }

  describe "Create comment on Article" do
    setup [:setup_fixture, :login_user_1]

    test "renders comment when data is valid", %{
      conn: conn,
      articles: articles,
      current_user_1: current_user_1
    } do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = post(conn, Routes.comment_path(conn, :create, slug), comment: @create_attrs)

      assert %{"comment" => comment} = json_response(conn, 201)

      assert comment["body"] == @create_attrs.body
      assert comment["author"] == current_user_1.id
      assert comment["createdAt"] != nil
      assert comment["updatedAt"] != nil
    end

    test "renders error when data is invalid", %{
      conn: conn,
      articles: articles,
      current_user_1: current_user_1
    } do
      {article, _} = List.pop_at(articles, 0)
      slug = article.slug

      conn = post(conn, Routes.comment_path(conn, :create, slug), comment: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # -----------------------------------------
  defp setup_fixture(%{conn: conn}) do
    %{
      current_user_1: current_user_1,
      current_user_2: current_user_2,
      articles: articles,
      comments: comments
    } = comment_fixture()

    conn = conn |> put_req_header("accept", "application/json")

    {:ok,
     conn: conn,
     articles: articles,
     current_user_1: current_user_1,
     current_user_2: current_user_2,
     comments: comments}
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
