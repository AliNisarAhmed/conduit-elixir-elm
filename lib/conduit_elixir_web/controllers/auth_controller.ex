defmodule ConduitElixirWeb.AuthController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Auth

  import ConduitElixirWeb.Plugs.Auth

  action_fallback ConduitElixirWeb.FallbackController

  plug :require_guest_user when action in [:register, :login]
  plug :require_authenticated_user when action in [:get_current_user]

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

  def get_current_user(%Plug.Conn{assigns: assigns} = conn, _params) do
    conn
    |> render("current_user.json", user: assigns.current_user)
  end

  def update_user(%Plug.Conn{assigns: assigns} = conn, %{
        "user" => updates
      }) do
    with {:ok, user} <-
           Auth.update_user(assigns.current_user, updates) do
      conn
      |> render("current_user.json", user: user)
    end
  end
end
