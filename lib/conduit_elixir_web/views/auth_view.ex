defmodule ConduitElixirWeb.AuthView do
  use ConduitElixirWeb, :view

  alias ConduitElixirWeb.AuthView

  def render("register.json", %{:user => user}) do
    render_one(user, AuthView, "user.json", as: :user)
  end

  def render("login.json", %{token: token, user: user}) do
    %{
      user: render_one(user, AuthView, "user.json", as: :user) |> Map.put(:token, token)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      bio: user.bio
    }
  end
end
