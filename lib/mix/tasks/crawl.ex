defmodule Mix.Tasks.Crawl do
  @moduledoc false
  @shortdoc "Run Crawler"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    RealtorBot.Crawler.start()
  end
end
