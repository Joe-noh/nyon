defmodule Nyon.Identities do
  import Ecto.Query

  alias Nyon.Repo
  alias Nyon.Identities.{User, SpotifyAccount}

  def find_user(id) do
    User
    |> where([u], u.id == ^id)
    |> join(:left, [u], s in assoc(u, :spotify_account))
    |> preload([..., s], spotify_account: s)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def signup_user(spotify_account_params) do
    user_changeset = %User{} |> User.changeset(%{})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, user_changeset)
    |> Ecto.Multi.insert(:spotify_account, fn %{user: user} ->
      user
      |> Ecto.build_assoc(:spotify_account)
      |> SpotifyAccount.changeset(spotify_account_params)
    end)
    |> Repo.transaction()
  end
end
