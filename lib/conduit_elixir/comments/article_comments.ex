defmodule ConduitElixir.Comments.ArticleComment do 
  use Ecto.Schema 

  import Ecto.Changeset

  alias ConduitElixir.Auth.User
  alias ConduitElixir.Articles.Article

  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  schema "article_comments" do 
    field :body, :string

    belongs_to :user, User
    belongs_to :article, Article

    timestamps(@timestamps_opts)
  end

  def create_changeset(comment, article_id, attrs, current_user) do 
    comment 
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> put_change(:user_id, current_user.id)
    |> put_change(:article_id, article_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:article_id)
  end

end
