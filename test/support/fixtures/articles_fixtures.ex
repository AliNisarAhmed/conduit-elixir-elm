defmodule ConduitElixir.ArticlesFixtures do
  alias ConduitElixir.Auth
  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Articles

  alias ConduitElixir.Repo

  import Ecto.Query, warn: false

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ConduitElixir.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture() do
    {:ok, current_user_1} =
      Auth.register_user(%{
        email: "test-1@test.com",
        username: "test_user_1",
        password: "abcd1234"
      })

    {:ok, current_user_2} =
      Auth.register_user(%{
        email: "test-2@test.com",
        username: "test_user_2",
        password: "abcd1234"
      })

    attrs_1 = [
      %{
        "body" => "some body 1",
        "description" => "some description 1",
        "title" => "some title 1",
        "tagList" => []
      },
      %{
        "body" => "some body 2",
        "description" => "some description 2",
        "title" => "some title 2",
        "tagList" => []
      }
    ]

    attrs_2 = [
      %{
        "body" => "some body 3",
        "description" => "some description 3",
        "title" => "some title 3",
        "tagList" => []
      },
      %{
        "body" => "some body 4",
        "description" => "some description 4",
        "title" => "some title 4",
        "tagList" => []
      }
    ]

    for attr <- attrs_1 do
      {:ok, article} =
        attr
        |> Articles.create_article(current_user_1)

      article
    end

    for attr <- attrs_2 do
      {:ok, article} =
        attr
        |> Articles.create_article(current_user_2)

      article
    end

    Articles.favorite_article(current_user_1.id, "some-title-4")

    Repo.all(from a in Article, preload: [:user, :tags, :article_favorites])
  end
end
