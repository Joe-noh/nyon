defmodule Nyon.Twitter do
  defstruct [
    id_str: "",
    screen_name: "",
    name: "",
    profile_image_url_https: ""
  ]

  def fetch_profile!(access_token, access_token_secret) do
    [consumer_key: consumer_key, consumer_secret: consumer_secret] =
      Application.get_env(:nyon, :twitter)
      |> Keyword.take([:consumer_key, :consumer_secret])

    ExTwitter.configure(:process,
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      access_token: access_token,
      access_token_secret: access_token_secret
    )

    ExTwitter.verify_credentials() |> to_struct()
  end

  defp to_struct(profile) do
    struct(__MODULE__, Map.from_struct(profile))
  end
end
