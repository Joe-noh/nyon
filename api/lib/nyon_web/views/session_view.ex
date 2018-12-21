defmodule NyonWeb.SessionView do
  use NyonWeb, :view
  alias NyonWeb.{SessionView, UserView}

  def render("show.json", %{user: user, token: token}) do
    %{data: render_one(%{user: user, token: token}, SessionView, "session.json")}
  end

  def render("session.json", %{session: %{user: user, token: token}}) do
    %{
      user: UserView.render("user.json", %{user: user}),
      token: token
    }
  end
end
