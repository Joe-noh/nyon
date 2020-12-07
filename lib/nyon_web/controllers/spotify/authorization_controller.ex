defmodule NyonWeb.Spotify.AuthorizationController do
  use NyonWeb, :controller

  alias Nyon.Identities

  def authorize(conn, _params) do
    redirect(conn, external: Spotify.Authorization.url())
  end

  def callback(conn, params = %{"code" => _}) do
    conn = authenticate_with_spotify(conn, params)
    %{access_token: access_token, refresh_token: refresh_token} = conn.assigns

    Spotify.Credentials.new(access_token, refresh_token)
    |> Spotify.Profile.me()
    |> case do
      {:ok, %Spotify.Profile{id: spotify_user_id}} ->
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

  defp authenticate_with_spotify(conn, params) do
    {:ok, conn} = Spotify.Authentication.authenticate(conn, params)

    %{"spotify_access_token" => access_token, "spotify_refresh_token" => refresh_token} = conn.cookies

    conn
    |> delete_resp_cookie("spotify_access_token")
    |> delete_resp_cookie("spotify_refresh_token")
    |> assign(:access_token, access_token)
    |> assign(:refresh_token, refresh_token)
  end
end
