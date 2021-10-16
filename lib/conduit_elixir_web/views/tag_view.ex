defmodule ConduitElixirWeb.TagView do
  use ConduitElixirWeb, :view
  alias ConduitElixirWeb.TagView

  def render("index.json", %{tags: tags}) do
    render_many(tags, TagView, "tag.json")
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    tag.title
  end
end
