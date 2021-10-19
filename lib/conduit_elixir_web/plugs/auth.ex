defmodule ConduitElixirWeb.Plugs.Auth do
  import Plug.Conn

  alias ConduitElixir.Auth

  def fetch_current_user(conn, _opts) do
    token = fetch_token(get_req_header(conn, "authorization"))
    user = token && Auth.get_user_by_token(token)
    assign(conn, :current_user, user)
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns.current_user != nil do
      conn
    else
      halt_on_unauthorized_user(conn)
    end
  end

  def require_guest_user(conn, _opts) do
    if conn.assigns.current_user do
      halt_on_unauthorized_user(conn)
    else
      conn
    end
  end

  # --------------------------------------------------------------------------------

  defp halt_on_unauthorized_user(conn) do
    conn
    |> put_status(401)
    |> Phoenix.Controller.put_view(ConduitElixirWeb.ErrorView)
    |> Phoenix.Controller.render(:"401")
    |> halt()
  end

  defp fetch_token([]), do: nil

  defp fetch_token([token | _tail]) do
    token
    |> String.replace("Token", "")
    |> String.trim()
  end
end
