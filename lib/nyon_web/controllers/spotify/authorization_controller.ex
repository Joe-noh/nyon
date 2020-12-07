defmodule NyonWeb.Spotify.AuthorizationController do
  use NyonWeb, :controller

  def authorize(conn, _params) do
    redirect conn, external: Spotify.Authorization.url
  end

  def callback(conn, params = %{"code" => _}) do
    conn = authenticate_with_spotify(conn, params)
    %{access_token: access_token, refresh_token: refresh_token} = conn.assigns

    Spotify.Credentials.new(access_token, refresh_token)
    |> Spotify.Profile.me
    |> case do
      {:ok, %Spotify.Profile{id: _spotify_user_id}} ->
        # do signup or login

        conn |> redirect(to: "/")

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
