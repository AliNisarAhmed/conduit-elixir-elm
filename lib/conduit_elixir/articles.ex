defmodule ConduitElixir.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias ConduitElixir.Repo

  alias ConduitElixir.Articles.Article
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
        preload: [:tags, :article_favorites]
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
  def get_article!(slug) do
    get_article_by_slug(slug)
  end

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
    article_id = get_article_id_by_slug(slug)

    %ArticleFavorite{}
    |> ArticleFavorite.changeset(%{article_id: article_id, user_id: user_id})
    |> Repo.insert!()

    article = get_article_by_slug(slug)

    {:ok, article}
  end

  @doc """
  Unfavorite an article
  """
  def unfavorite_article(user_id, slug) do
    article_id = get_article_id_by_slug(slug)
    fav = Repo.get_by!(ArticleFavorite, user_id: user_id, article_id: article_id)

    Repo.delete!(fav)

    {:ok, get_article_by_slug(slug)}
  end

  # ----------------------------------------------------------------------------------

  defp get_article_id_by_slug(slug) do
    query =
      from a in Article,
        select: a.id

    Repo.get_by!(query, slug: slug)
  end

  defp get_article_by_slug(slug) do
    query =
      from a in Article,
        preload: [:tags, :article_favorites]

    Repo.get_by!(query, slug: slug)
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
