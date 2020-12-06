defmodule Nyon.Identities.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nyon.Identities.SpotifyAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_one :spotify_account, SpotifyAccount

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user = %__MODULE__{}, attrs) do
    user |> cast(attrs, [])
  end
end
