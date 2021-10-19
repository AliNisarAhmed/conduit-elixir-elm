defmodule ConduitElixir.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias ConduitElixir.Repo

  alias ConduitElixir.Articles.Article
  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Auth.User

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
  def create_article(%{"tagList" => tagList} = attrs \\ %{}, current_user) do
    tags =
      tagList
      |> Enum.map(fn t -> Tag.changeset(%Tag{}, %{title: t}) end)
      |> Enum.to_list()

    # %Article{}
    # |> Repo.preload([:tags, :users])
    # |> Article.changeset(attrs)
    # |> Ecto.Changeset.put_assoc(:tags, tags)
    # |> Ecto.Changeset.put_assoc(:users, %{id: user_id})
    # |> Repo.insert()

    #     %{}
    #     |> Ecto.Changeset.put_assoc(:articles, Article.changeset(%Article{}, attrs))
    #     |> Repo.preload([:tags])
    #     |> Ecto.Changeset.put_assoc(:tags, tags)
    #     |> Repo.insert()
    # User.assoc_changeset(%User{}, %{id: user_id})
    # |> IO.inspect()
  
    Ecto.build_assoc(current_user, :articles)
    |> IO.inspect()
    |> Article.changeset(attrs)
    |> IO.inspect()
    # |> Repo.preload([:tags])
    |> IO.inspect()
    |> Ecto.Changeset.put_assoc(:tags, tags)
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
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
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
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end
end
