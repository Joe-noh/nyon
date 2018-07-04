defmodule NyonWeb.MagicLinkControllerTest do
  use NyonWeb.ConnCase

  @attrs Factory.params_for(:magic_link)

  describe "new action" do
    test "renders form", %{conn: conn} do
      html = conn
        |> get(Routes.login_path(conn, :new))
        |> html_response(200)

      assert html =~ "Send Magic Link"
    end
  end

  describe "show action" do
    test "says that magic link was sent", %{conn: conn} do
      html = conn
        |> get(Routes.magic_link_path(conn, :show))
        |> html_response(200)

      assert html =~ "We sent a magic link to you"
    end
  end

  describe "create action" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.magic_link_path(conn, :create), magic_link: @attrs)

      assert redirected_to(conn) == Routes.magic_link_path(conn, :show)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      html = conn
        |> post(Routes.magic_link_path(conn, :create), magic_link: %{})
        |> html_response(200)

      assert html =~ "Send Magic Link"
    end
  end
end
