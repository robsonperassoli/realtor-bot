defmodule RealtorBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RealtorBot.Repo,
      # Start the Telemetry supervisor
      RealtorBotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RealtorBot.PubSub},
      # Start the Endpoint (http/https)
      RealtorBotWeb.Endpoint,
      # Start a worker by calling: RealtorBot.Worker.start_link(arg)
      # {RealtorBot.Worker, arg}
      RealtorBot.Crawler.ServerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RealtorBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RealtorBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
