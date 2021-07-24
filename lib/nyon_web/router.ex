defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NyonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Nyon.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NyonWeb do
    pipe_through :browser

    get "/signin", SigninController, :index

    scope "/spotify", Spotify do
      get "/authorize", AuthorizationController, :authorize
      get "/callback", AuthorizationController, :callback
    end

    scope "/music", Music do
      get "/", PlayerController, :index
      put "/play/:id", PlayerController, :play
      put "/pause", PlayerController, :pause
      post "/analysis/:id", PlayerController, :analysis
    end

    live "/", PageLive, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NyonWeb.Telemetry
    end
  end
end
