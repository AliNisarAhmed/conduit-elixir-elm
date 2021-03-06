defmodule ConduitElixir.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Tags.ArticleTag
  alias ConduitElixir.Articles.Article

  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  schema "tags" do
    field :title, :string

    many_to_many :articles, Article, join_through: ArticleTag

    timestamps(@timestamps_opts)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
