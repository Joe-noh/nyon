defmodule NyonWeb.PageLiveTest do
  use NyonWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "not logged in" do
    test "redirects to signup page", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/signup"}}} = live(conn, "/")
    end
  end
end
