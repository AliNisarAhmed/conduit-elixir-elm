defmodule ConduitElixir.Profiles do 

  import Ecto.Query, warn: false

  alias ConduitElixir.Repo
  alias ConduitElixir.Auth.User

  def get_profile(username) do 
    Repo.get_by(User, username: username)
  end

end
