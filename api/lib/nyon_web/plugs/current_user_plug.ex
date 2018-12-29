defmodule NyonWeb.CurrentUserPlug do
  import Plug.Conn

  def init(_), do: []

  def call(conn, _opts) do
    with ["Bearer " <> token | _] <- get_req_header(conn, "authorization"),
         {:ok, %{"user_id" => id}} <- NyonWeb.Token.verify_and_validate(token),
         {:ok, user} <- find_user(id) do
      conn |> assign(:current_user, user)
    else
      _ -> conn
    end
  end

  def find_user(id) do
    try do
      {:ok, Nyon.Identities.get_user!(id)}
    rescue
      _ -> nil
    end
  end
end
