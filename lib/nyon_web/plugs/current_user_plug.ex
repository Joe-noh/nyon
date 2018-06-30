defmodule NyonWeb.CurrentUserPlug do
  import Plug.Conn

  def init(_opts) do
    []
  end

  def call(conn, _opts) do
    conn
    |> fetch_session()
    |> get_session(:user_id)
    |> case do
      nil ->
        conn
      user_id ->
        assign_user(conn, user_id)
      end
  end

  defp assign_user(conn, user_id) do
    with {:ok, user} <- Nyon.Accounts.get_user_by(id: user_id) do
      conn |> assign(:current_user, user)
    else
     _ ->
      conn
    end
  end
end
