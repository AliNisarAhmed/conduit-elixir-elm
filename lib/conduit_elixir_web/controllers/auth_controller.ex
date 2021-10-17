defmodule ConduitElixirWeb.AuthController do 
  use ConduitElixirWeb, :controller 

  alias ConduitElixir.Auth 

  def register(conn, %{"user" => user_params}) do 
    with {:ok, user} <- Auth.register_user(user_params, [hash_password: true]) do 
      conn 
      |> put_status(201) 
      |> render("register.json", user: user)
    end
  end

end
