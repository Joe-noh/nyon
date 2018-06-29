defmodule NyonWeb.UserController do
  use NyonWeb, :controller

  alias Nyon.Accounts
  alias Nyon.Accounts.User

  def new(conn, %{"token" => token}) do
    case Accounts.get_magic_link_by_token(token) do
      {:ok, magic_link} ->
        case Accounts.get_user_by_email(magic_link.email) do
          {:ok, user} ->
            conn
            |> put_session(:user_id, user.id)
            |> configure_session(renew: true)
            |> redirect(to: Routes.user_path(conn, :show, user))
          {:error, :not_found} ->
            changeset = Accounts.change_user(%User{})
            render(conn, "new.html", changeset: changeset, magic_link: magic_link)
        end
      {:error, _} ->
        conn
        |> put_view(ErrorView)
        |> render("400.html")
    end
  end

  def create(conn, %{"user" => user_params = %{"token" => token}}) do
    with {:ok, _magic_link} <- Accounts.get_magic_link_by_token(token),
         {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: Routes.user_path(conn, :show, user))
    else
      {nil, _map} ->
        conn
        |> put_view(ErrorView)
        |> render("404.html")
      {:error, :not_found} ->
        conn
        |> put_view(ErrorView)
        |> render("400.html")
      {:error, changeset} ->
        {:ok, magic_link} = Accounts.get_magic_link_by_token(token)
        render(conn, "new.html", changeset: changeset, magic_link: magic_link)
    end
  end

  def create(conn, _params) do
    conn
    |> put_view(ErrorView)
    |> render("400.html")
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
