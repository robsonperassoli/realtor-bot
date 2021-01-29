defmodule RealtorBot.Crawler.ServerSupervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      RealtorBot.Crawler.Server
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
