defmodule Nyon.Identities.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Nyon.Identities.TwitterAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :name, :string
    field :display_name, :string

    has_one :twitter_account, TwitterAccount

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :display_name])
    |> validate_required([:name, :display_name])
    |> validate_length(:name, min: 1, max: 50)
    |> validate_length(:display_name, min: 1, max: 50)
    |> validate_format(:name, ~r/\A[\w]+\z/)
    |> unique_constraint(:name)
  end
end
