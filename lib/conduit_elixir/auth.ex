defmodule ConduitElixir.Auth do 
  @moduledoc """
  The Auth context
  """

  import Ecto.Query, warn: false 
  alias ConduitElixir.Repo 
  alias ConduitElixir.Auth.User

  def register_user(attrs, opts \\ []) do 
    %User{}
    |> User.registation_changeset(attrs, opts) 
    |> Repo.insert()
  end

end
