defmodule RealtorBotWeb.PageLive do
  use RealtorBotWeb, :live_view
  alias RealtorBot.RealEstate

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:listings, load_listings())}
  end

  @impl true
  def handle_event("toggle_discarded", %{"listing-id" => listing_id}, socket) do
    RealEstate.toggle_listing_discarded(listing_id)

    {:noreply,
     socket
     |> assign(:listings, load_listings())}
  end

  defp load_listings do
    RealEstate.list()
  end
end
