defmodule Nyon.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    cache_opts = [
      ttl_check: :timer.seconds(10),
      ttl: :timer.hours(24)
    ]

    children = [
      supervisor(Nyon.Repo, []),
      supervisor(Nyon.Web.Endpoint, []),

      worker(ConCache, [cache_opts, [name: Nyon.Post.cache_name]]),
    ]

    opts = [strategy: :one_for_one, name: Nyon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
