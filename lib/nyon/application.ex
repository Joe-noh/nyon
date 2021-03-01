defmodule Nyon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies, [])

    children = [
      {Cluster.Supervisor, [topologies, [name: Nyon.ClusterSupervisor]]},
      # Start the Ecto repository
      Nyon.Repo,
      # Start the Telemetry supervisor
      NyonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Nyon.PubSub},
      # Start the Endpoint (http/https)
      NyonWeb.Endpoint,
      Nyon.Minesweeper.Server,
      Nyon.Jukebox.QueueServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Nyon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NyonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
