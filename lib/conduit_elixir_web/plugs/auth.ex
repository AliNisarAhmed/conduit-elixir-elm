defmodule ConduitElixirWeb.Plugs.Auth do
  import Plug.Conn

  alias ConduitElixir.Auth

  def fetch_current_user(conn, _opts) do
    with token <- fetch_token(get_req_header(conn, "authorization")),
         {:ok, user} <- token && Auth.get_user_by_token(token) do
      assign(conn, :current_user, user)
    else
      nil -> assign(conn, :current_user, nil)
      e -> assign(conn, :current_user, e)
    end
  end

  def optional_authentication(
        %Plug.Conn{
          assigns: %{current_user: {:error, _}}
        } = conn,
        _opts
      ) do
    halt_on_unauthorized_user(conn)
  end

  def optional_authentication(
        conn,
        _opts
      ) do
    conn
  end

  def require_authenticated_user(
        %Plug.Conn{
          assigns: %{current_user: {:error, _}}
        } = conn,
        _opts
      ) do
    halt_on_unauthorized_user(conn)
  end

  def require_authenticated_user(
        %Plug.Conn{
          assigns: %{current_user: nil}
        } = conn,
        _opts
      ) do
    halt_on_unauthorized_user(conn)
  end

  def require_authenticated_user(conn, _opts) do
    conn
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
