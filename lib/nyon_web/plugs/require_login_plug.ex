defmodule NyonWeb.RequireLoginPlug do
  import Plug.Conn

  alias NyonWeb.Router.Helpers, as: Routes

  def init(_opts) do
    []
  end

  def call(conn, _opts) do
    current_user = conn.assigns |> Map.get(:current_user)
    do_call(conn, current_user)
  end

  defp do_call(conn, nil) do
    conn
    |> Phoenix.Controller.redirect(to: Routes.login_path(conn, :new))
    |> halt()
  end

  defp do_call(conn, _current_user) do
    conn
  end
end
