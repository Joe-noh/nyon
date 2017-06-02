defmodule Nyon.Web.Router do
  use Nyon.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Nyon.Web do
    pipe_through :api
  end
end
