defmodule ConduitElixir.ArticlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ConduitElixir.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        description: "some description",
        title: "some title"
      })
      |> ConduitElixir.Articles.create_article()

    article
  end
end
