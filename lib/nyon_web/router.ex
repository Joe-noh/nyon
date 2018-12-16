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
  end
end
