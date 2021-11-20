defmodule ConduitElixir.Profiles do 

  import Ecto.Query, warn: false

  alias Ecto.Changeset

  alias ConduitElixir.Repo
  alias ConduitElixir.Auth
  alias ConduitElixir.Auth.User
  alias ConduitElixir.Profiles.UserFollows

  def get_profile(username) do 
    Repo.get_by(User, username: username)
  end

  def follow_user(username, current_user) do 
    user = Auth.get_user_by_username(username)

    %UserFollows{} 
    |> UserFollows.changeset()
    |> Changeset.put_assoc(:follower, user)
    |> Changeset.put_assoc(:followed, current_user)
    |> Repo.insert()

    get_profile(username)
  end

  def unfollow_user(username, current_user) do 
    user = Auth.get_user_by_username(username)

    query = 
      from uf in UserFollows,
      where: uf.follower_id == ^current_user.id,
      where: uf.followed_user_id == ^user.id

    Repo.delete_all(query)

    get_profile(username)

  end

end
