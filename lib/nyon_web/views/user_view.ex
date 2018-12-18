defmodule NyonWeb.UserView do
  use NyonWeb, :view
  alias NyonWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      display_name: user.display_name,
      avatar_url: user.avatar_url
    }
  end
end
