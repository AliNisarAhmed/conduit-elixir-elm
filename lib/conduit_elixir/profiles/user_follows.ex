defmodule ConduitElixir.Profiles.UserFollows do
  use Ecto.Schema

  alias ConduitElixir.Auth.User

  import Ecto.Changeset

  schema "user_follows" do
    belongs_to :follower, User, foreign_key: :follower_id
    belongs_to :followed, User, foreign_key: :followed_user_id
  end

  def changeset(user_follows, attrs \\ %{}) do
    user_follows
    |> cast(attrs, [])
    |> unique_constraint([:follower_id, :followed_user_id])
  end
end
