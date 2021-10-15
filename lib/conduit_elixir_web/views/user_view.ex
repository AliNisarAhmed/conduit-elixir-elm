defmodule ConduitElixirWeb.UserView do
  use ConduitElixirWeb, :view
  alias ConduitElixirWeb.UserView

  def render("index.json", %{users: users}) do
    %{users: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do 
    %{
      id: user.id, 
      firstName: user.first_name,
      lastName: user.last_name, 
      email: user.email
    } 
  end
end
