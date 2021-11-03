defmodule ConduitElixir.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias ConduitElixir.Repo
  import Ecto.Query

  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Tags.ArticleTag
  alias ConduitElixir.Auth.User

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string

    many_to_many :tags, Tag, join_through: ArticleTag, on_replace: :delete
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def create_changeset(article, attrs, current_user) do
    article
    |> cast(attrs, [:title, :body, :description])
    |> validate_required([:title, :body])
    |> put_change(:user_id, current_user.id)
    |> put_assoc(:tags, parse_tags(attrs["tagList"]))
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
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

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
