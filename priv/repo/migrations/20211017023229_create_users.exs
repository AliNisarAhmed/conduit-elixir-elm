defmodule ConduitElixir.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  @timestamps_opts [type: :utc_datetime_usec, usec: true]

  def change do
    create table(:users) do 
      add :email, :string, size: 160, null: false 
      add :hashed_password, :string, null: false 
      add :username, :string, size: 25, null: false
      add :bio, :string


      timestamps(@timestamps_opts)
    end

    create unique_index("users", [:email])
    create unique_index("users", [:username])

  end
end
