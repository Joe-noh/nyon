# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nyon,
  ecto_repos: [Nyon.Repo]

# Configures the endpoint
config :nyon, Nyon.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Wwgi0g6jLxElsuWjdX952flNPT1SiJXXbSlw2hPgMZ3cf02gkWu0Z5tiYfZ1Mufp",
  render_errors: [view: Nyon.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Nyon.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
