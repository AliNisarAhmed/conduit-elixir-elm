defmodule ConduitElixirWeb.ProfileController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Profiles

  import ConduitElixirWeb.Plugs.Auth

  plug :require_authenticated_user when action in [:follow_user, :unfollow_user]

  def show(%Plug.Conn{} = conn, %{"username" => username}) do
    case Profiles.get_profile(username) do
      nil -> {:error, :not_found}
      user_profile -> render(conn, "show_profile.json", user_profile: user_profile)
    end
  end

  def follow_user(%Plug.Conn{assigns: assigns} = conn, %{"username" => username}) do
    with user_profile <- Profiles.follow_user(username, assigns.current_user) do
      render(conn, "show_profile.json", user_profile: user_profile)
    end
  end

  def unfollow_user(%Plug.Conn{assigns: assigns} = conn, %{"username" => username}) do 
    with user_profile <- Profiles.unfollow_user(username, assigns.current_user) do 
      render(conn, "show_profile.json", user_profile: user_profile)
    end
  end

end
