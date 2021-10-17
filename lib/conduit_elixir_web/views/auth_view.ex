defmodule ConduitElixirWeb.AuthView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.AuthView

  def render("register.json", %{:user => user}) do
    render_one(user, AuthView, "privileged_user.json", as: :user)
  end

  def render("privileged_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      bio: user.bio
    }
  end
end
