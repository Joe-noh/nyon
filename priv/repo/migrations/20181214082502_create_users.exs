defmodule Nyon.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :display_name, :string

      timestamps()
    end

    create unique_index(:users, [:name], name: :users_name_index)
  end
end
