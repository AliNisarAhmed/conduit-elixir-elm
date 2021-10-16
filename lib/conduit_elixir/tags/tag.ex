defmodule ConduitElixir.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Tags.ArticleTag
  alias ConduitElixir.Articles.Article

  schema "tags" do
    field :title, :string

    many_to_many :articles, Article, join_through: ArticleTag

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
