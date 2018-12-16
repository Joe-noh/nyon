defmodule NyonWeb.UserController do
  use NyonWeb, :controller

  alias Nyon.Identities

  action_fallback NyonWeb.FallbackController

  plug NyonWeb.RequireLoginPlug
  plug :restrict_access when action in [:update, :delete]

  def show(conn, %{"id" => id}) do
    user = Identities.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Identities.get_user!(id)

    with {:ok, user} <- Identities.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Identities.get_user!(id)

    with {:ok, _user} <- Identities.delete_user(user) do
      conn |> send_resp(:no_content, "")
    end
  end

  defp restrict_access(conn, _opts) do
    restrict_access(conn, conn.assigns.current_user, conn.params)
  end

  defp restrict_access(conn, %{id: user_id}, %{"id" => user_id}) do
    conn
  end

  defp restrict_access(conn, _current_user, _params) do
    conn |> Plug.Conn.send_resp(:forbidden, "") |> Plug.Conn.halt()
  end
end
