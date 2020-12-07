defmodule NyonWeb.Spotify.AuthorizationControllerTest do
  use NyonWeb.ConnCase, async: false

  import Mock

  describe "authorize" do
    test "redirects to spotify login page", %{conn: conn} do
      conn = get(conn, Routes.authorization_path(conn, :authorize))

      assert redirected_to(conn) |> String.starts_with?("https://accounts.spotify.com/authorize")
    end
  end

  describe "callback" do
    test "redirects to root", %{conn: conn} do
      with_mocks [spotify_auth_mock(), profile_success_mock()] do
        conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

        assert redirected_to(conn) == "/"
        assert get_flash(conn) == %{}
      end
    end

    test "does not set tokens into cookies", %{conn: conn} do
      with_mocks [spotify_auth_mock(), profile_success_mock()] do
        conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

        refute conn.cookies |> Map.has_key?("spotify_access_token")
        refute conn.cookies |> Map.has_key?("spotify_refresh_token")
      end
    end

    test "redirects to root when code is missing", %{conn: conn} do
      conn = get(conn, Routes.authorization_path(conn, :callback))

      assert redirected_to(conn) == "/"
      assert get_flash(conn) == %{}
    end

    test "show error when fetching spotify profile failed", %{conn: conn} do
      with_mocks [spotify_auth_mock(), profile_failure_mock()] do
        conn = get(conn, Routes.authorization_path(conn, :callback), code: "CODE")

        assert %{"error" => _} = get_flash(conn)
      end
    end
  end

  defp spotify_auth_mock do
    response = %HTTPoison.Response{
      status_code: 200,
      body: Jason.encode!(%{access_token: "ACCESS_TOKEN", refresh_token: "REFRESH_TOKEN"})
    }

    {Spotify.AuthRequest, [], [post: fn _ -> {:ok, response} end]}
  end

  defp profile_success_mock do
    {Spotify.Profile, [], [me: fn _ -> {:ok, %Spotify.Profile{id: "SPOTIFY_USER_ID"}} end]}
  end

  defp profile_failure_mock do
    response = %HTTPoison.Response{
      status_code: 400,
      body: Jason.encode!(%{error: "!"})
    }

    {Spotify.Profile, [], [me: fn _ -> {:error, response} end]}
  end
end
