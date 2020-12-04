defmodule NyonWeb.PageLiveTest do
  use NyonWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
  end

  test "increment counter", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, html} =
      view
      |> element("#increment")
      |> render_click()
      |> Floki.parse_document()

    assert html |> Floki.find("#count") |> Floki.text() == "1"
  end

  test "decrement counter", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    {:ok, html} =
      view
      |> element("#decrement")
      |> render_click()
      |> Floki.parse_document()

    assert html |> Floki.find("#count") |> Floki.text() == "-1"
  end
end
