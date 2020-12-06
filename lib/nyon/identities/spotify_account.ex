defmodule Nyon.Identities.SpotifyAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nyon.Identities.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spotify_accounts" do
    field :access_token, :string
    field :refresh_token, :string
    field :token_expires_at, :utc_datetime_usec

    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(spotify_account, attrs) do
    spotify_account
    |> cast(attrs, [:access_token, :refresh_token, :token_expires_at])
    |> validate_required([:access_token, :refresh_token, :token_expires_at])
  end
end
