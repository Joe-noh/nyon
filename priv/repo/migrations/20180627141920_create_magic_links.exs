defmodule Nyon.Repo.Migrations.CreateMagicLinks do
  use Ecto.Migration

  def change do
    create table(:magic_links) do
      add :email, :string, null: false
      add :token, :string, null: false
      add :expired_at, :naive_datetime, null: false

      timestamps()
    end
  end
end
