defmodule ConduitElixir.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Favorites.ArticleFavorite
  alias ConduitElixir.Comments.ArticleComment
  alias ConduitElixir.Auth.User
  alias ConduitElixir.Profiles.UserFollows

  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :username, :string
    field :bio, :string
    field :image, :string

    has_many :articles, Article, on_delete: :delete_all
    has_many :article_favorites, ArticleFavorite, on_delete: :delete_all
    has_many :article_comments, ArticleComment, on_delete: :delete_all

    many_to_many :following, User,
      join_through: UserFollows,
      join_keys: [follower_id: :id, followed_user_id: :id],
      on_delete: :delete_all

    many_to_many :followers, User,
      join_through: UserFollows,
      join_keys: [followed_user_id: :id, follower_id: :id],
      on_delete: :delete_all

    # many_to_many :followers, User, join_through: UserFollows,on_delete: :delete_all, foreign_key: :id
    # has_many :following, User, on_delete: :delete_all, foreign_key: :id

    timestamps(@timestamps_opts)
  end

  def registation_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :username, :password, :bio, :image])
    |> validate_email()
    |> validate_username()
    |> validate_password(opts)
  end

  def update_changeset(user, updates) do
    user
    |> change()
    |> put_change(:email, Map.get(updates, "email"))
    |> put_change(:bio, Map.get(updates, "bio"))
    |> put_change(:image, Map.get(updates, "image"))
    |> validate_email()
  end

  def assoc_changeset(user, attrs) do
    user
    |> cast(attrs, [])
  end

  def valid_password?(%ConduitElixir.Auth.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  # --------------------------------------------------------------------------------

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, ConduitElixir.Repo)
    |> unique_constraint(:email)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_format(:username, ~r/[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$/,
      message: "must be a valid username"
    )
    |> validate_length(:username, max: 25)
    |> unsafe_validate_unique(:username, ConduitElixir.Repo)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 80)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hashed_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hashed_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
