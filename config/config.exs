# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

with {:ok, content} <- File.read(".env") do
  content
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "="))
  |> Enum.each(fn [key, val] ->
    System.put_env(key, val)
  end)
end

config :nyon,
  ecto_repos: [Nyon.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :nyon, NyonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: NyonWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Nyon.PubSub, adapter: Phoenix.PubSub.PG2]

config :nyon, :twitter,
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken, default_signer: System.get_env("SECRET_KEY_BASE")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
