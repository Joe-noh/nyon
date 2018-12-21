defmodule Nyon.Repo.Migrations.CreateTwitterAccounts do
  use Ecto.Migration

  def change do
    create table(:twitter_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :twitter_id, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:twitter_accounts, [:user_id], name: :twitter_accounts_user_id_index)

    create unique_index(:twitter_accounts, [:twitter_id], name: :twitter_accounts_twitter_id_index)
  end
end
