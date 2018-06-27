defmodule NyonWeb.MagicLinkController do
  use NyonWeb, :controller

  alias Nyon.Accounts
  alias Nyon.Accounts.MagicLink

  def show(conn, _params) do
    render(conn, "show.html")
  end

  def new(conn, _params) do
    changeset = Accounts.change_magic_link(%MagicLink{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"magic_link" => magic_link_params}) do
    case Accounts.create_magic_link(magic_link_params) do
      {:ok, magic_link} ->
        Routes.user_url(conn, :new, %{token: magic_link.token})
        |> IO.inspect

        conn
        |> redirect(to: Routes.magic_link_path(conn, :show))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
