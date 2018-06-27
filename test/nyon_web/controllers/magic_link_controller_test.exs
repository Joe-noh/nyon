defmodule NyonWeb.MagicLinkControllerTest do
  use NyonWeb.ConnCase

  @attrs %{email: "hello@example.com"}

  describe "new magic_link" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.magic_link_path(conn, :new)
      assert html_response(conn, 200) =~ "New Magic link"
    end
  end

  describe "create magic_link" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.magic_link_path(conn, :create), magic_link: @attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.magic_link_path(conn, :show, id)

      conn = get conn, Routes.magic_link_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Magic link"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.magic_link_path(conn, :create), magic_link: %{}
      assert html_response(conn, 200) =~ "New Magic link"
    end
  end
end
