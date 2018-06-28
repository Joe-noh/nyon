defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NyonWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    get "/login", MagicLinkController, :new
    get "/login/sent", MagicLinkController, :show
    post "/login", MagicLinkController, :create
  end

  if Mix.env == :dev do
    forward "/mailer", Bamboo.SentEmailViewerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", NyonWeb do
  #   pipe_through :api
  # end
end
