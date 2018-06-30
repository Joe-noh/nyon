defmodule NyonWeb.PostController do
  use NyonWeb, :controller

  alias Nyon.{Notes, Accounts}
  alias Nyon.Notes.Post

  plug :assign_user
  plug :assign_post when action in [:delete]
  plug :correct_user when action in [:delete]

  def index(conn, _params) do
    %{user: user} = conn.assigns
    posts = Notes.list_posts()

    render(conn, "index.html", posts: posts, user: user)
  end

  def new(conn, _params) do
    changeset = Notes.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Notes.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}) do
    %{post: post} = conn.assigns
    {:ok, _post} = Notes.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp assign_user(conn, _opts) do
    id = conn.params |> Map.get("user_id")
    conn |> assign(:user, Accounts.get_user!(id))
  end

  defp assign_post(conn, _opts) do
    id = conn.params |> Map.get("id")
    conn |> assign(:post, Notes.get_post!(id))
  end

  defp correct_user(conn, _opts) do
    %{current_user: current_user, user: user, post: post} = conn.assigns
      |> Map.take([:current_user, :user, :post])

    if current_user.id == user.id and current_user.id == post.user_id do
      conn
    else
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
