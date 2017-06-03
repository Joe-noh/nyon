defmodule Nyon.Post do
  @cache {:global, :posts}

  def all do
    @cache
    |> ConCache.ets
    |> :ets.tab2list
    |> Enum.map(fn {_key, post} -> post end)
  end

  def store(body) do
    case build_post(body) do
      nil  -> nil
      post ->
        key = random_string()
        ConCache.put(@cache, key, post)
        post
    end
  end

  def clear do
    @cache
    |> ConCache.ets
    |> :ets.delete_all_objects
  end

  def cache_name do
    @cache
  end

  defp build_post(body) do
    trimmed = String.trim(body)
    post = %{"body" => body}

    case String.length(trimmed) do
      0 -> nil
      _ -> post
    end
  end

  defp random_string do
    :crypto.strong_rand_bytes(64)
    |> Base.url_encode64
    |> binary_part(0, 64)
  end
end
