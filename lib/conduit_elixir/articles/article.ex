defmodule ConduitElixir.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias ConduitElixir.Repo
  import Ecto.Query

  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Tags.ArticleTag
  alias ConduitElixir.Auth.User
  alias ConduitElixir.Favorites.ArticleFavorite

  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :slug, :string

    many_to_many :tags, Tag, join_through: ArticleTag, on_replace: :delete
    belongs_to :user, User

    has_many :article_favorites, ArticleFavorite

    timestamps(@timestamps_opts)
  end

  @doc false
  def create_changeset(article, attrs, current_user) do
    article
    |> cast(attrs, [:title, :body, :description])
    |> validate_required([:title, :body])
    |> put_change(:user_id, current_user.id)
    |> put_assoc(:tags, parse_tags(Map.get(attrs, "tagList", [])))
    |> put_slug()
    |> foreign_key_constraint(:user_id)
  end

  defp put_slug(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, title} ->
        changeset
        |> put_change(:slug, slugify_title(title))

      _ ->
        changeset

    end
  end

  defp slugify_title(title) do
    title
    |> String.downcase()
    |> String.split(~r/\s/)
    |> Enum.take(10)
    |> Enum.map(fn s -> String.replace(s, ~r/[^\w-]+/, "") end)
    |> Enum.join("-")
  end

  defp parse_tags(tagList) do
    tagList
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> insert_and_get_all()
  end

  defp insert_and_get_all([]) do
    []
  end

  defp insert_and_get_all(titles) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:microsecond)

    placeholders = %{timestamp: timestamp}

    maps =
      Enum.map(
        titles,
        &%{
          title: &1,
          inserted_at: {:placeholder, :timestamp},
          updated_at: {:placeholder, :timestamp}
        }
      )

    Repo.insert_all(
      Tag,
      maps,
      placeholders: placeholders,
      on_conflict: :nothing
    )

    Repo.all(from t in Tag, where: t.title in ^titles)
  end
end
