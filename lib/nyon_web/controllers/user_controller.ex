defmodule NyonWeb.UserController do
  use NyonWeb, :controller

  alias Nyon.Accounts
  alias Nyon.Accounts.User

  plug :assign_user when action in [:show, :edit, :update, :delete]
  plug :correct_user when action in [:edit, :update, :delete]

  def new(conn, %{"token" => token}) do
    case Accounts.get_effective_magic_link(token) do
      {:ok, magic_link} ->
        case Accounts.get_user_by(email: magic_link.email) do
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
    with {:ok, _magic_link} <- Accounts.get_effective_magic_link(token),
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
        {:ok, magic_link} = Accounts.get_effective_magic_link(token)
        render(conn, "new.html", changeset: changeset, magic_link: magic_link)
    end
  end

  def create(conn, _params) do
    conn
    |> put_view(ErrorView)
    |> render("400.html")
  end

  def show(conn, %{"id" => _}) do
    user = conn.assigns |> Map.get(:user)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => _}) do
    user = conn.assigns |> Map.get(:user)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => _, "user" => user_params}) do
    user = conn.assigns |> Map.get(:user)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _}) do
    user = conn.assigns |> Map.get(:user)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.login_path(conn, :new))
  end

  defp assign_user(conn, _opts) do
    id = conn.params |> Map.get("id")
    conn |> assign(:user, Accounts.get_user!(id))
  end

  defp correct_user(conn, _opts) do
    %{current_user: current_user, user: user} = Map.take(conn.assigns, [:current_user, :user])

    if current_user.id == user.id do
      conn
    else
      conn |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
