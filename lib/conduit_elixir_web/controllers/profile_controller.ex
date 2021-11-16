defmodule ConduitElixirWeb.ProfileController do
  use ConduitElixirWeb, :controller

  alias ConduitElixir.Profiles

  def show(%Plug.Conn{} = conn, %{"username" => username}) do
    case Profiles.get_profile(username) do
      nil -> {:error, :not_found}
      user_profile -> render(conn, "show_profile.json", user_profile: user_profile)
    end
  end
end
