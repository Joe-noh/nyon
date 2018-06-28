defmodule Nyon.Accounts.MagicLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "magic_links" do
    field :email, :string
    field :token, :string
    field :expired_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(magic_link, attrs) do
    magic_link
    |> cast(attrs, [:email])
    |> generate_token()
    |> generate_expired_at()
    |> validate_required([:email, :token, :expired_at])
  end

  defp generate_token(changeset) do
    case get_change(changeset, :token) do
      nil ->
        token = :crypto.strong_rand_bytes(32) |> Base.encode64() |> binary_part(0, 32)
        put_change(changeset, :token, token)
      _token ->
        changeset
    end
  end

  defp generate_expired_at(changeset) do
    case get_change(changeset, :expired_at) do
      nil ->
        expired_at = NaiveDateTime.utc_now() |> NaiveDateTime.add(3600, :seconds)
        put_change(changeset, :expired_at, expired_at)
      _token ->
        changeset
    end
  end
end
