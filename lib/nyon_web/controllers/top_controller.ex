defmodule NyonWeb.TopController do
  use NyonWeb, :controller

  def index(conn, _params) do
    conn |> redirect(to: Routes.player_path(conn, :index))
  end
end
