defmodule Nyon.Identities do
  import Ecto.Query

  alias Nyon.Repo
  alias Nyon.Identities.{User, SpotifyAccount}

  def find_user(id) do
    User
    |> join(:left, [u], s in assoc(u, :spotify_account))
    |> where([u, s], u.id == ^id)
    |> preload([..., s], spotify_account: s)
    |> get_one()
  end

  def find_user_by_spotify_id(spotify_id) do
    User
    |> join(:left, [u], s in assoc(u, :spotify_account))
    |> where([u, s], s.spotify_user_id == ^spotify_id)
    |> preload([..., s], spotify_account: s)
    |> get_one()
  end

  def signup_or_login_user(%{spotify_user_id: spotify_user_id} = spotify_account_params) do
    case find_user_by_spotify_id(spotify_user_id) do
      {:ok, user} ->
        case update_spotify_account(user.spotify_account, spotify_account_params) do
          {:ok, _} -> {:ok, :login, user}
          _error -> {:error, :login}
        end

      {:error, :not_found} ->
        case signup_user(spotify_account_params) do
          {:ok, %{user: user}} -> {:ok, :signup, user}
          _error -> {:error, :signup}
        end
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

  def refresh_if_expired(account = %SpotifyAccount{}) do
    if SpotifyAccount.token_expired?(account) do
      account
      |> SpotifyAccount.credentials()
      |> Spotify.Authentication.refresh()
      |> case do
        {:ok, creds} ->
          params = %{
            access_token: creds.access_token,
            token_expires_at: DateTime.utc_now() |> DateTime.add(3600, :second)
          }

          update_spotify_account(account, params)

        _ ->
          :error
      end
    else
      {:ok, account}
    end
  end

  defp update_spotify_account(account, params) do
    account
    |> SpotifyAccount.changeset(params)
    |> Repo.update()
  end

  defp get_one(query) do
    query
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end
end
