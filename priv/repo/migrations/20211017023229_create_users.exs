defmodule ConduitElixir.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do 
      add :email, :string, size: 160, null: false 
      add :hashed_password, :string, null: false 
      add :username, :string, size: 25, null: false
      add :bio, :string


      timestamps()
    end

    create unique_index("users", [:email])
    create unique_index("users", [:username])

  end
end
