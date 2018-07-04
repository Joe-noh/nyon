defmodule NyonWeb.TopController do
  use NyonWeb, :controller

  def index(conn, _params) do
    posts = Nyon.Notes.list_posts()

    render conn, "index.html", posts: posts
  end
end
