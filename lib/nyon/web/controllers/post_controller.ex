defmodule Nyon.Web.PostController do
  use Nyon.Web, :controller

  def index(conn, _params) do
    posts = Nyon.Post.all

    conn
    |> put_status(200)
    |> render("index.json", %{posts: posts})
  end

  def create(conn, %{"body" => body}) do
    post = Nyon.Post.store(body)

    conn
    |> put_status(201)
    |> render("show.json", %{post: post})
  end
end
