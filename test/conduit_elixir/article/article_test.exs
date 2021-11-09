defmodule ConduitElixir.Articles.ArticleTest do
  use ConduitElixir.DataCase, async: true
  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Auth.User

  describe "Article Context - Test Slugify functions" do
    test "The title is slugified properly - small title" do
      attrs = %{
        "body" => "some body",
        "description" => "some description",
        "title" => "some title",
        "tagList" => []
      }

      current_user = %User{id: 1}

      article_changeset =
        %Article{}
        |> Article.create_changeset(attrs, current_user)

      assert article_changeset.changes.slug == "some-title"
    end

    test "Long title is slugified with first 10 words" do
      attrs = %{
        "body" => "some body",
        "description" => "some description",
        "title" =>
          "Some very long title containing more than 10 words which should be slugified properly",
        "tagList" => []
      }

      current_user = %User{id: 1}

      article_changeset =
        %Article{}
        |> Article.create_changeset(attrs, current_user)

      assert article_changeset.changes.slug == "some-very-long-title-containing-more-than-10-words-which"
    end
  end
end
