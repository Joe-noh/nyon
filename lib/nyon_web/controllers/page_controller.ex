defmodule NyonWeb.PageController do
  use NyonWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
