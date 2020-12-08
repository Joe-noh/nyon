defmodule NyonWeb.SigninController do
  use NyonWeb, :controller

  def index(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        conn |> render("index.html")

      _user ->
        conn |> redirect(to: "/")
    end
  end
end
