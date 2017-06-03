defmodule Nyon.Web.PostController do
  use Nyon.Web, :controller

  def index(conn, _params) do
    posts = Nyon.Post.all

    conn
    |> put_status(200)
    |> render("index.json", %{posts: posts})
  end

  def create(conn, %{"body" => body}) do
    case Nyon.Post.store(body) do
      nil ->
        conn
        |> put_status(422)
        |> assign(:attrs, %{body: "body is required"})
        |> render(Nyon.Web.ErrorView, "422.json")
      post ->
        conn
        |> put_status(201)
        |> render("show.json", %{post: post})
    end
  end
end
