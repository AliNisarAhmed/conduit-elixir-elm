defmodule ConduitElixir.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Tags.ArticleTag
  alias ConduitElixir.Auth.User

  schema "articles" do
    field :body, :string
    field :description, :string
    field :title, :string

    many_to_many :tags, Tag, join_through: ArticleTag 
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :description])
    |> validate_required([:title, :body])
  end
end
