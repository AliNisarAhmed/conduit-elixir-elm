defmodule ConduitElixir.Repo.Migrations.CreateUserFollowsTable do
  use Ecto.Migration

  def change do
    create table(:user_follows) do 
      add :follower_id, references(:users, on_delete: :delete_all)
      add :followed_user_id, references(:users, on_delete: :delete_all)
    end

    create unique_index("user_follows", [:follower_id, :followed_user_id])
  end
end
