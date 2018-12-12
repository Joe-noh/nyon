defmodule NyonWeb.Router do
  use NyonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NyonWeb do
    pipe_through :api
  end
end
