defmodule ConduitElixir.Comments.ArticleComment do 
  use Ecto.Schema 

  import Ecto.Changeset

  alias ConduitElixir.Auth.User

  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  schema "article_comments" do 
    field :body, :string

    belongs_to :user, User

    timestamps(@timestamps_opts)
  end

  def create_changeset(comment, attrs, current_user) do 
    comment 
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> put_change(:user_id, current_user.id)
    |> foreign_key_constraint(:user_id)
  end

end
