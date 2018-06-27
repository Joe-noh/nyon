defmodule NyonWeb.MagicLinkController do
  use NyonWeb, :controller

  alias Nyon.Accounts
  alias Nyon.Accounts.MagicLink

  def show(conn, %{"id" => id}) do
    magic_link = Accounts.get_magic_link!(id)
    render(conn, "show.html", magic_link: magic_link)
  end

  def new(conn, _params) do
    changeset = Accounts.change_magic_link(%MagicLink{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"magic_link" => magic_link_params}) do
    case Accounts.create_magic_link(magic_link_params) do
      {:ok, magic_link} ->
        conn
        |> put_flash(:info, "Magic link created successfully.")
        |> redirect(to: Routes.magic_link_path(conn, :show, magic_link))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
