defmodule NyonWeb.PostControllerTest do
  use NyonWeb.ConnCase

  alias Nyon.{Notes, Accounts}

  @post_attrs Factory.params_for(:post)
  @user_attrs Factory.params_for(:user)

  defp login(%{conn: conn}) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    conn = Helpers.login(conn, user)

    %{conn: conn, user: user}
  end

  defp create_post(%{user: user}) do
    {:ok, post} = Notes.create_post(user, @post_attrs)

    %{post: post}
  end

  describe "new post" do
    setup [:login]

    test "renders form", %{conn: conn, user: user} do
      html = conn
        |> get(Routes.user_post_path(conn, :new, user))
        |> html_response(200)

      html =~ "New Post"
    end
  end

  describe "create post" do
    setup [:login]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.user_post_path(conn, :create, user), post: @post_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      html = conn
        |> post(Routes.user_post_path(conn, :create, user), post: %{body: ""})
        |> html_response(200)

      html =~ "New Post"
    end
  end

  describe "delete post" do
    setup [:login, :create_post]

    test "deletes chosen post", %{conn: conn, user: user, post: post} do
      conn = delete(conn, Routes.user_post_path(conn, :delete, user, post))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end
end
