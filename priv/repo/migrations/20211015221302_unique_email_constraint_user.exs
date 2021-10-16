defmodule ConduitElixir.Repo.Migrations.UniqueEmailConstraintUser do
  use Ecto.Migration

  def change do
    create unique_index("users", [:email])
  end
end
