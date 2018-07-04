defmodule NyonWeb.ViewHelpers do
  def datetime(time) do
    {{year, month, day}, {hour, minute, _second}} = NaiveDateTime.to_erl(time)
    "#{year}/#{month}/#{day} #{hour}:#{minute}"
  end

  def gravatar_url(email) do
    uri = %URI{
      scheme: "https",
      host: "secure.gravatar.com/avatar/",
      query: URI.encode_query(%{s: 32}),
      path: :crypto.hash(:md5, String.downcase(email)) |> Base.encode16(case: :lower),
    }

    to_string(uri)
  end
end
