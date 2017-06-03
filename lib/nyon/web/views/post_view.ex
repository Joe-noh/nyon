defmodule Nyon.Web.PostView do
  use Nyon.Web, :view

  def render("index.json", %{posts: posts}) do
    %{"posts" => render_many(posts, __MODULE__, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{"post" => render_one(post, __MODULE__, "post.json")}
  end

  def render("post.json", %{post: post}) do
    Map.take(post, ~w[body])
  end
end
