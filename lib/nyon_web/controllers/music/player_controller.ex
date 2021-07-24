defmodule NyonWeb.Music.PlayerController do
  use NyonWeb, :controller

  alias Nyon.Identities

  def index(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        conn |> redirect(to: Routes.signin_path(conn, :index))

      user ->
        {:ok, account} = Identities.refresh_if_expired(user.spotify_account)

        conn
        |> assign(:account, account)
        |> render("index.html")
    end
  end

  def analysis(conn, %{"id" => id}) do
    user = conn.assigns.current_user

    with {:ok, account} <- Identities.refresh_if_expired(user.spotify_account),
         {:ok, analysis} <- Sptfy.Track.get_audio_analysis(account.access_token, id: id) do
      conn |> json(analysis)
    else
      _error ->
        # TODO
        conn |> json(%{})
    end
  end

  def play(conn, %{"device_id" => device_id, "id" => id}) do
    user = conn.assigns.current_user

    params = [
      device_id: device_id,
      uris: ["spotify:track:#{id}"]
    ]

    with {:ok, account} <- Identities.refresh_if_expired(user.spotify_account),
         :ok <- Sptfy.Player.play(account.access_token, params) do
      conn |> json(%{})
    else
      _error ->
        # TODO
        conn |> json(%{})
    end
  end

  def pause(conn, %{"device_id" => device_id}) do
    user = conn.assigns.current_user

    params = [
      device_id: device_id
    ]

    with {:ok, account} <- Identities.refresh_if_expired(user.spotify_account),
         :ok <- Sptfy.Player.pause(account.access_token, params) do
      conn |> json(%{})
    else
      _error ->
        # TODO
        conn |> json(%{})
    end
  end
end
