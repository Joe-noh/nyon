defmodule Nyon.Twitter do
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

    ExTwitter.verify_credentials()
  end
end
