defmodule ConduitElixir.Repo.Migrations.AddSlugToArticle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :slug, :text, null: false
    end

    create unique_index("articles", [:slug])
  end
end
