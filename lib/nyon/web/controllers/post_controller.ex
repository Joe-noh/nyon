defmodule Nyon.Web.PostController do
  use Nyon.Web, :controller

  @cache {:global, :posts}

  def index(conn, _params) do
    posts = @cache
      |> ConCache.ets
      |> :ets.tab2list
      |> Enum.map(fn {_key, post} -> post end)

    conn
    |> put_status(200)
    |> json(%{posts: posts})
  end

  def create(conn, %{"body" => body}) do
    body = String.trim(body)
    post = %{body: body}

    if String.length(body) > 0 do
      ConCache.put(@cache, random_string(), post)
    end

    conn
    |> put_status(201)
    |> json(%{post: post})
  end

  defp random_string do
    :crypto.strong_rand_bytes(64)
    |> Base.url_encode64
    |> binary_part(0, 64)
  end
end
