defmodule ConduitElixir.Auth do
  @moduledoc """
  The Auth context
  """

  import Ecto.Query, warn: false
  alias ConduitElixir.Repo
  alias ConduitElixir.Auth.User

  def register_user(attrs, opts \\ []) do
    %User{}
    |> User.registation_changeset(attrs, opts)
    |> Repo.insert()
  end

  def get_user_by_id(user_id) do 
    Repo.get_by(User, id: user_id)
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  def get_token(%User{id: user_id }) do 
    Phoenix.Token.sign(ConduitElixirWeb.Endpoint, "user auth", user_id)
  end

  def get_user_by_token(token) do 
    case Phoenix.Token.verify(ConduitElixirWeb.Endpoint, "user auth", token, max_age: 86400) do 
      {:ok, user_id } ->  get_user_by_id(user_id)
      {:error, :invalid} -> nil
    end
  end


end
