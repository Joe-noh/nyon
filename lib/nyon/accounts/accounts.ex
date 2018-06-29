defmodule Nyon.Accounts do
  import Ecto.Query, warn: false

  alias Nyon.Repo
  alias Nyon.Accounts.{User, MagicLink}

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(condition) do
    User
    |> where(^condition)
    |> wrap_one()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_effective_magic_link(token) do
    now = NaiveDateTime.utc_now()

    MagicLink
    |> where([m], m.token == ^token)
    |> where([m], m.expired_at > ^now)
    |> order_by([m], desc: m.inserted_at)
    |> first()
    |> wrap_one()
  end

  def create_magic_link(attrs \\ %{}) do
    %MagicLink{}
    |> MagicLink.changeset(attrs)
    |> Repo.insert()
  end

  def update_magic_link(%MagicLink{} = magic_link, attrs) do
    magic_link
    |> MagicLink.changeset(attrs)
    |> Repo.update()
  end

  def delete_magic_link(%MagicLink{} = magic_link) do
    Repo.delete(magic_link)
  end

  def change_magic_link(%MagicLink{} = magic_link) do
    MagicLink.changeset(magic_link, %{})
  end

  defp wrap_one(query) do
    query
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}
      struct ->
        {:ok, struct}
    end
  end
end
