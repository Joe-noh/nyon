defmodule NyonWeb.UserController do
  use NyonWeb, :controller

  alias Nyon.Identities

  action_fallback NyonWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Identities.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

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
end
