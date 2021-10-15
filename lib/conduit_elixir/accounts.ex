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

end
