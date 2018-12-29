defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug NyonWeb.CurrentUserPlug
  end

  scope "/api", NyonWeb do
    pipe_through :api

    resources "/users", UserController, only: [:show, :update, :delete]
    resources "/sessions", SessionController, only: [:create]

    scope "/oauth", Oauth do
      resources "/authorize_url", AuthorizeUrlController, only: [:show], singleton: true
    end
  end
end
