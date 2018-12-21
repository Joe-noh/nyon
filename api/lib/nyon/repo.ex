defmodule Nyon.Repo do
  use Ecto.Repo,
    otp_app: :nyon,
    adapter: Ecto.Adapters.Postgres
end
