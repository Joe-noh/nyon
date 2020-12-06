defmodule Nyon.Repo.Migrations.CreateSpotifyAccounts do
  use Ecto.Migration

  def change do
    create table(:spotify_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :access_token, :string, null: false
      add :refresh_token, :string, null: false
      add :token_expires_at, :utc_datetime, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:spotify_accounts, [:user_id])
  end
end
