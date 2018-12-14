defmodule NyonWeb.UserControllerTest do
  use NyonWeb.ConnCase

  alias ExUnitAssertMatch, as: Match
  alias Nyon.Identities

  @pattern Match.map(
             %{
               "id" => Match.binary(),
               "name" => Match.binary(),
               "display_name" => Match.binary()
             },
             exact_same_keys: true
           )

  @post_params %{
    "name" => "john_doe",
    "display_name" => "John Doe",
    "twitter_id" => "123456789"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /users" do
    test "renders user and twitter account", %{conn: conn} do
      json =
        conn
        |> post(Routes.user_path(conn, :create), user: @post_params)
        |> json_response(201)
        |> Map.get("data")

      Match.assert(@pattern, json)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      json =
        conn
        |> post(Routes.user_path(conn, :create), user: %{@post_params | "name" => ""})
        |> json_response(422)

      assert Map.has_key?(json, "errors")
    end
  end

  describe "PUT /users/:id" do
    setup [:create_user]

    test "renders user and twitter account", %{conn: conn, user: user} do
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
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn
      |> delete(Routes.user_path(conn, :delete, user))
      |> response(204)
    end
  end

  defp create_user(_) do
    {:ok, user} = Identities.create_user(@post_params)
    %{user: user}
  end
end
