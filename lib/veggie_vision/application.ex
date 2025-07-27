defmodule VeggieVision.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VeggieVisionWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:veggie_vision, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VeggieVision.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: VeggieVision.Finch},
      # Start a worker by calling: VeggieVision.Worker.start_link(arg)
      # {VeggieVision.Worker, arg},
      # Start to serve requests, typically the last entry
      VeggieVisionWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VeggieVision.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VeggieVisionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
