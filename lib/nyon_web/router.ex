defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NyonWeb do
    pipe_through :api

    resources "/users", UserController, only: [:show, :create, :update, :delete]
  end
end
