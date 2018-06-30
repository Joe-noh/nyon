defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug NyonWeb.CurrentUserPlug
    plug NyonWeb.RequireLoginPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NyonWeb do
    pipe_through :browser

    get "/login", MagicLinkController, :new, as: :login
    post "/login", MagicLinkController, :create
    get "/login/sent", MagicLinkController, :show

    get "/users/new", UserController, :new
    post "/users", UserController, :create

    scope "/" do
      pipe_through :auth

      get "/", PageController, :index
      resources "/users", UserController, only: [:index, :show, :edit, :update, :delete] do
        resources "/posts", PostController
      end
    end
  end

  if Mix.env == :dev do
    forward "/mailer", Bamboo.SentEmailViewerPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", NyonWeb do
  #   pipe_through :api
  # end
end
