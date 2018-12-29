defmodule NyonWeb.Oauth.AuthorizeUrlController do
  use NyonWeb, :controller

  action_fallback NyonWeb.FallbackController

  def show(conn, _params) do
    twitter_module = Application.get_env(:nyon, :twitter_module, Nyon.Twitter)

    with {:ok, authorize_url} <- twitter_module.fetch_authorize_url() do
      render(conn, "show.json", authorize_url: authorize_url)
    end
  end
end
