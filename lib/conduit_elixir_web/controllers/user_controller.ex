defmodule ConduitElixirWeb.UserController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Accounts.User
  alias ConduitElixir.Accounts

  action_fallback ConduitElixirWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} = Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end
end
