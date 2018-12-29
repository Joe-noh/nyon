defmodule NyonWeb.SessionControllerTest do
  use NyonWeb.ConnCase

  alias ExUnitAssertMatch, as: Match
  alias Nyon.Identities

  @pattern Match.map(%{
             "user" =>
               Match.map(%{
                 "id" => Match.binary(),
                 "name" => Match.binary(),
                 "display_name" => Match.binary(),
                 "avatar_url" => Match.binary()
               }),
             "token" => Match.binary()
           })

  @post_params %{
    "token" => "twitter_token",
    "verifier" => "twitter_token_verifier"
  }

  defmodule TwitterMock do
    def fetch_profile(_, _) do
      profile = %Nyon.Twitter.Profile{
        name: "John Doe",
        screen_name: "john_doe",
        user_id: "123456789"
      }

      {:ok, profile}
    end

    def fetch_access_token(_, _) do
      oauth_token = %Nyon.Twitter.OauthToken{
        token: "foo",
        token_secret: "bar",
        screen_name: "john_doe",
        user_id: "123456789"
      }

      {:ok, oauth_token}
    end
  end

  setup_all do
    Application.put_env(:nyon, :twitter_module, TwitterMock)
    :ok
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /sessions" do
    setup [:create_user]

    test "renders user and token", %{conn: conn} do
      json =
        conn
        |> post(Routes.session_path(conn, :create), @post_params)
        |> json_response(201)
        |> Map.get("data")

      Match.assert(@pattern, json)
    end

    test "create user when not exist", %{conn: conn, user: user} do
      Identities.delete_user(user)

      json =
        conn
        |> post(Routes.session_path(conn, :create), @post_params)
        |> json_response(201)
        |> Map.get("data")

      Match.assert(@pattern, json)
      assert Identities.get_user!(json["user"]["id"])
    end
  end

  defp create_user(_) do
    {:ok, user} =
      Identities.create_user(%{
        "name" => "john_doe",
        "display_name" => "John Doe",
        "twitter_id" => "123456789"
      })

    %{user: user}
  end
end
