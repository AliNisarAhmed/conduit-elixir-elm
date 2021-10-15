defmodule ConduitElixir.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Accounts.User

  schema "articles" do
    field :title, :string
    field :body, :string 
    field :description, :string
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
