# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

config :nyon, Nyon.Repo,
  # ssl: true,
  url: "${DATABASE_URL}",
  pool_size: String.to_integer("${POOL_SIZE}")

config :nyon, NyonWeb.Endpoint,
  http: [
    port: String.to_integer("${PORT}"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: "${SECRET_KEY_BASE}"

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :nyon, NyonWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
