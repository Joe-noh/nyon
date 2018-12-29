defmodule NyonWeb.Oauth.AuthorizeUrlView do
  use NyonWeb, :view
  alias NyonWeb.Oauth.AuthorizeUrlView

  def render("show.json", %{authorize_url: authorize_url}) do
    %{data: render_one(authorize_url, AuthorizeUrlView, "authorize_url.json")}
  end

  def render("authorize_url.json", %{authorize_url: authorize_url}) do
    %{url: authorize_url}
  end
end
