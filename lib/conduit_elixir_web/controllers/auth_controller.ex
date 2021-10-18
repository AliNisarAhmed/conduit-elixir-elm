defmodule ConduitElixirWeb.AuthController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Auth

  import ConduitElixirWeb.Plugs.Auth

  plug :require_guest_user when action in [:register, :login]

  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Auth.register_user(user_params, hash_password: true) do
      conn
      |> put_status(201)
      |> render("register.json", user: user)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    if user = Auth.get_user_by_email_and_password(email, password) do
      token = Auth.get_token(user)

      conn
      |> render("login.json", user: user, token: token)
    else
      {:error, :bad_request, "Invalid credentials"}
    end
  end
end
