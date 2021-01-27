defmodule NyonWeb.Spotify.AuthorizationControllerTest do
  use NyonWeb.ConnCase, async: false

  import Mock

  alias Nyon.Identities

  describe "authorize" do
    test "redirects to spotify login page", %{conn: conn} do
      conn = get(conn, Routes.authorization_path(conn, :authorize))

      assert redirected_to(conn) |> String.starts_with?("https://accounts.spotify.com/authorize")
    end
  end

  describe "callback success with new user" do
    setup_with_mocks [spotify_auth_mock(), profile_success_mock()], %{conn: conn} do
      conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

      %{conn: conn}
    end

    test "redirects to root", %{conn: conn} do
      assert redirected_to(conn) == "/"
      assert get_session(conn, :current_user_id)
      assert get_flash(conn) == %{"info" => "Welcome!"}
    end

    test "does not set tokens into cookies", %{conn: conn} do
      refute conn.cookies |> Map.has_key?("spotify_access_token")
      refute conn.cookies |> Map.has_key?("spotify_refresh_token")
    end
  end

  describe "callback success with existing user" do
    setup_with_mocks [spotify_auth_mock(), profile_success_mock("spotify_user")], %{conn: conn} do
      {:ok, %{user: user}} = Fixtures.spotify_account(%{spotify_user_id: "spotify_user"}) |> Identities.signup_user()
      conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

      %{conn: conn, user: user}
    end

    test "redirects to root", %{conn: conn, user: user} do
      assert redirected_to(conn) == "/"
      assert get_session(conn, :current_user_id) == user.id
      assert get_flash(conn) == %{"info" => "Welcome back!"}
    end

    test "does not set tokens into cookies", %{conn: conn} do
      refute conn.cookies |> Map.has_key?("spotify_access_token")
      refute conn.cookies |> Map.has_key?("spotify_refresh_token")
    end
  end

  describe "callback failure" do
    test "show error when fetching spotify profile failed", %{conn: conn} do
      with_mocks [spotify_auth_mock(), profile_failure_mock()] do
        conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

        assert %{"error" => _} = get_flash(conn)
        assert get_session(conn, :current_user_id) == nil
      end
    end

    test "redirects to root when code is missing", %{conn: conn} do
      conn = get(conn, Routes.authorization_path(conn, :callback))

      assert redirected_to(conn) == "/"
      assert get_session(conn, :current_user_id) == nil
      assert get_flash(conn) == %{}
    end
  end

  defp spotify_auth_mock do
    response = %Sptfy.Object.OAuthResponse{
      access_token: "ACCESS_TOKEN",
      refresh_token: "REFRESH_TOKEN"
    }

    {Sptfy.OAuth, [], [get_token: fn _, _, _, _ -> {:ok, response} end]}
  end

  defp profile_success_mock(spotify_id \\ "SPOTIFY_USER_ID") do
    {Sptfy.Profile, [], [get_my_profile: fn _ -> {:ok, %Sptfy.Object.PrivateUser{id: spotify_id}} end]}
  end

  defp profile_failure_mock do
    response = %Sptfy.Object.OAuthError{
      error: "ERROR",
      error_description: "ERROR_DESCRIPTION"
    }

    {Sptfy.Profile, [], [get_my_profile: fn _ -> {:error, response} end]}
  end
end
