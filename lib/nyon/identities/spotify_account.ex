defmodule Nyon.Identities.SpotifyAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nyon.Identities.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "spotify_accounts" do
    field :spotify_user_id, :string
    field :access_token, :string
    field :refresh_token, :string
    field :token_expires_at, :utc_datetime_usec

    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(spotify_account, attrs) do
    spotify_account
    |> cast(attrs, [:spotify_user_id, :access_token, :refresh_token, :token_expires_at])
    |> validate_required([:spotify_user_id, :access_token, :refresh_token, :token_expires_at])
    |> unique_constraint(:spotify_user_id, name: "spotify_accounts_spotify_user_id_index")
  end
end
