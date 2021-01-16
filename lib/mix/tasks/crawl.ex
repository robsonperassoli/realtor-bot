defmodule Mix.Tasks.Crawl do
  @moduledoc false
  @shortdoc "Run Crawler"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    {:ok, _started} = Application.ensure_all_started(:realtor_bot)

    RealtorBot.Crawler.start()
  end
end
