defmodule NyonWeb.UserControllerTest do
  use NyonWeb.ConnCase

  alias ExUnitAssertMatch, as: Match
  alias Nyon.Identities

  @pattern Match.map(
             %{
               "id" => Match.binary(),
               "name" => Match.binary(),
               "display_name" => Match.binary(),
               "avatar_url" => Match.binary()
             },
             exact_same_keys: true
           )

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "PUT /users/:id" do
    setup [:create_user, :put_auth_header]

    test "updates and renders the user", %{conn: conn, user: user} do
      json =
        conn
        |> put(Routes.user_path(conn, :update, user), user: %{display_name: "john"})
        |> json_response(200)
        |> Map.get("data")

      Match.assert(@pattern, json)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      json =
        conn
        |> put(Routes.user_path(conn, :update, user), user: %{display_name: ""})
        |> json_response(422)

      assert Map.has_key?(json, "errors")
    end
  end

  describe "DELETE /users/:id" do
    setup [:create_user, :put_auth_header]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn
      |> delete(Routes.user_path(conn, :delete, user))
      |> response(204)
    end
  end

  defp create_user(_) do
    {:ok, user} =
      Identities.create_user(%{
        "name" => "john_doe",
        "display_name" => "John Doe",
        "avatar_url" => "https://example.com/img.png",
        "twitter_id" => "123456789"
      })

    %{user: user}
  end

  defp put_auth_header(%{conn: conn, user: user}) do
    token = NyonWeb.Token.generate_and_sign!(%{"user_id" => user.id})
    conn = conn |> put_req_header("authorization", "Bearer #{token}")

    %{conn: conn}
  end
end
