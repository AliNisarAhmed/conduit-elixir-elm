defmodule ConduitElixir.Profiles do
  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias ConduitElixir.Repo
  alias ConduitElixir.Auth
  alias ConduitElixir.Auth.User
  alias ConduitElixir.Profiles.UserFollows

  def get_profile(username, current_user) do
    user_query = 
      from u in User,
      where: u.username == ^username

    follower_query = 
      from uf in User,
      where: uf.id == ^current_user.id

    Repo.one(from u in user_query, preload: [followers: ^follower_query])
  end

  def follow_user(username, current_user) do
    user = Auth.get_user_by_username(username)

    %UserFollows{}
    |> UserFollows.changeset()
    |> Changeset.put_assoc(:follower, current_user)
    |> Changeset.put_assoc(:followed, user)
    |> Repo.insert()

    get_profile(username, current_user)
  end

  def unfollow_user(username, current_user) do
    user = Auth.get_user_by_username(username)

    query =
      from uf in UserFollows,
        where: uf.follower_id == ^current_user.id,
        where: uf.followed_user_id == ^user.id

    Repo.delete_all(query)

    get_profile(username, current_user)
  end
end
