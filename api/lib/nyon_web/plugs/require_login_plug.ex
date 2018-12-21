defmodule NyonWeb.RequireLoginPlug do
  import Plug.Conn

  def init(_), do: []

  def call(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn |> send_resp(401, "") |> halt()
    end
  end
end
