# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nyon,
  ecto_repos: [Nyon.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :nyon, NyonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xjzLWOk2AVkHfmuw8s+0DOrOPRY+66KGI1PI0o7neIcBMB3vNx1p51mSmFzFtF0E",
  render_errors: [view: NyonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nyon.PubSub,
  live_view: [signing_salt: "e5RzYXfi"]

config :nyon, :spotify,
  client_id: System.get_env("SPOTIFY_CLIENT_ID"),
  client_secret: System.get_env("SPOTIFY_CLIENT_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
