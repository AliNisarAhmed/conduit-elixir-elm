defmodule ConduitElixirWeb.ProfileView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.ProfileView

  def render("show_profile.json", %{user_profile: user_profile}) do
    %{
      profile:
        render_one(user_profile, ProfileView, "profile.json", %{user_profile: user_profile})
    }
  end

  def render("profile.json", %{user_profile: user_profile}) do
    %{
      username: user_profile.username,
      bio: user_profile.bio,
      following: current_user_following?(user_profile.followers)
    }
  end

  # --------------------------------------------------------------

  defp current_user_following?([]), do: false
  defp current_user_following?(nil), do: false
  defp current_user_following?(_), do: true
end
