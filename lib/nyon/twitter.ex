defmodule Nyon.Identities.Twitter do
  def fetch_profile!(access_token, access_token_secret) do
    ExTwitter.configure(:process,
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: access_token,
      access_token_secret: access_token_secret
    )

    ExTwitter.verify_credentials()
  end
end
