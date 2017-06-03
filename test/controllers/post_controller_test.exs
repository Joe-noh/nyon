defmodule Nyon.Web.PostControllerTest do
  use Nyon.Web.ConnCase, async: false

  describe "index" do
    setup %{conn: conn} do
      Nyon.Post.clear

      post(conn, post_path(conn, :create), %{body: "Hey"})
      post(conn, post_path(conn, :create), %{body: "What's"})
      post(conn, post_path(conn, :create), %{body: "Up"})

      :ok
    end

    test "returns list of posts", %{conn: conn} do
      json = conn
        |> get(post_path(conn, :index))
        |> json_response(200)

      assert json["posts"] |> length == 3
    end
  end

  describe "create" do
    test "creates a post and return it", %{conn: conn} do
      json = conn
        |> post(post_path(conn, :create), %{body: "Hello"})
        |> json_response(201)

      assert json["post"] == %{"body" => "Hello"}
    end

    test "returns error when the body is blank", %{conn: conn} do
      json = conn
        |> post(post_path(conn, :create), %{body: "   "})
        |> json_response(422)

      assert json["errors"]["attrs"]
    end
  end
end
