defmodule Nyon.CurrentUserPlug do
  alias Nyon.Identities

  def init(_) do
  end

  def call(conn, _params) do
    with user_id when user_id != nil <- Plug.Conn.get_session(conn, :current_user_id),
         {:ok, user} <- Identities.find_user(user_id) do
      conn |> Plug.Conn.assign(:current_user, user)
    else
      _ -> conn |> Plug.Conn.assign(:current_user, nil)
    end
  end
end
