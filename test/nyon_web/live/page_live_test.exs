defmodule NyonWeb.PageLiveTest do
  use NyonWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "not logged in" do
    @tag skip: "for now"
    test "redirects to signin page", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/signin"}}} = live(conn, "/")
    end
  end
end
