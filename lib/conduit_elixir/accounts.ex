defmodule ConduitElixir.Accounts do 

  import Ecto.Query, warn: false 

  alias ConduitElixir.Repo
  alias ConduitElixir.Accounts.User

  def list_users() do 
    Repo.all(User)
  end

  def create_user(attrs \\ %{}) do 
    %User{}
    |> User.changeset(attrs) 
    |> Repo.insert()
  end

  def get_user_by_id(user_id) do 
    Repo.get(User, user_id)
  end

end
