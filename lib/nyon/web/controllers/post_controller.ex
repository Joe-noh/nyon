defmodule Nyon.Web.PostController do
  use Nyon.Web, :controller

  def index(conn, _params) do
    conn
  end

  def create(conn, %{"body" => body}) do
    conn
  end
end
