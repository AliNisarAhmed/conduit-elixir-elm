defmodule ConduitElixir.ArticlesFixtures do
  alias ConduitElixir.Auth.User

  @moduledoc """
  This module defines test helpers for creating
  entities via the `ConduitElixir.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture() do
    {:ok, article} =
      %{
        "body" => "some body",
        "description" => "some description",
        "title" => "some title",
        "tagList" => []
      }
      |> ConduitElixir.Articles.create_article(%User{id: 1})

    article
  end
end
