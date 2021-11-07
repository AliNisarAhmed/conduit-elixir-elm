defmodule ConduitElixir.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias ConduitElixir.Repo

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Auth.User
  alias ConduitElixir.Favorites.ArticleFavorite

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(
      from a in Article,
        preload: [:tags]
    )
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}, current_user) do
    %Article{}
    |> Article.create_changeset(attrs, current_user)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, _attrs) do
    article
    # |> Article.changeset(attrs)
    # |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Favorite an Article
  """
  def favorite_article(user_id, slug) do
    query = 
      from a in Article, 
      preload: [:tags]

    article = Repo.get_by!(query, slug: slug)

    %ArticleFavorite{}
    |> ArticleFavorite.changeset(%{article_id: article.id, user_id: user_id})
    |> Repo.insert!()

    {:ok, article}
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking article changes.

  # ## Examples

  #     iex> change_article(article)
  #     %Ecto.Changeset{data: %Article{}}

  # """
  # def change_article(%Article{} = article, attrs \\ %{}) do
  #   Article.changeset(article, attrs)
  # end
end
