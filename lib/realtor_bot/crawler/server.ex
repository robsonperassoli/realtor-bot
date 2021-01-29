defmodule RealtorBot.Crawler.Server do
  use GenServer

  @name :crawler_server

  defp schedule_execution() do
    next_execution =
      Timex.now()
      |> Timex.shift(hours: 4)

    millis_until_next_execution = Timex.diff(next_execution, Timex.now(), :milliseconds)
    IO.puts("Scheduled next execution for #{next_execution}")

    Process.send_after(self(), :crawl, millis_until_next_execution)
  end

  # client
  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  # server
  def init(state) do
    schedule_execution()

    {:ok, state}
  end

  def handle_info(:crawl, state) do
    RealtorBot.Crawler.start()

    {:noreply, state}
  end
end
