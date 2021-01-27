defmodule NyonWeb.Spotify.AuthorizationController do
  use NyonWeb, :controller

  alias Nyon.Identities
  alias Sptfy.Object.{OAuthResponse, PrivateUser}

  def authorize(conn, _params) do
    %{client_id: client_id, callback_url: callback_url, scopes: scopes} = Nyon.spotify_config()

    redirect(conn, external: Sptfy.OAuth.url(client_id, callback_url, %{scope: scopes}))
  end

  def callback(conn, %{"code" => code}) do
    {:ok, %OAuthResponse{access_token: access_token, refresh_token: refresh_token}} = authenticate_with_spotify(code)

    case Sptfy.Profile.get_my_profile(access_token) do
      {:ok, %PrivateUser{id: spotify_user_id}} ->
        spotify_account_params = %{
          spotify_user_id: spotify_user_id,
          access_token: access_token,
          refresh_token: refresh_token,
          token_expires_at: DateTime.utc_now() |> DateTime.add(3600, :second)
        }

        case Identities.signup_or_login_user(spotify_account_params) do
          {:ok, :login, user} ->
            conn
            |> put_session(:current_user_id, user.id)
            |> put_flash(:info, "Welcome back!")
            |> redirect(to: "/")

          {:ok, :signup, user} ->
            conn
            |> put_session(:current_user_id, user.id)
            |> put_flash(:info, "Welcome!")
            |> redirect(to: "/")

          {:error, :login} ->
            conn
            |> put_flash(:error, "Logging in failed. Try again later.")
            |> redirect(to: "/")

          {:error, :signup} ->
            conn
            |> put_flash(:error, "Signing up failed. Try again later.")
            |> redirect(to: "/")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "Fetching profile failed. Try again later.")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn |> redirect(to: "/")
  end

  defp authenticate_with_spotify(code) do
    %{client_id: client_id, client_secret: client_secret, callback_url: callback_url} = Nyon.spotify_config()

    Sptfy.OAuth.get_token(client_id, client_secret, code, callback_url)
  end
end
