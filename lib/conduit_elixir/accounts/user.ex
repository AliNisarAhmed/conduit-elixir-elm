defmodule ConduitElixir.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Articles.Article

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    has_many :articles, Article

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> unique_constraint(:email)
  end
end
