defmodule ConduitElixir.Tags.ArticleTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ConduitElixir.Tags.Tag
  alias ConduitElixir.Articles.Article

  schema "article_tags" do
    belongs_to :tag, Tag
    belongs_to :article, Article 
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:article_id, :tag_id])
    |> validate_required([:article_id, :tag_id])
    |> unique_constraint([:article_id, :tag_id])
  end
end
