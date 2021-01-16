defmodule RealtorBot.RealEstate.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listings" do
    field :description, :string
    field :agent, :string
    field :agent_listing_code, :string
    field :discarded, :boolean, default: false
    field :listing_url, :string
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [
      :description,
      :agent,
      :agent_listing_code,
      :listing_url,
      :discarded,
      :image_url
    ])
    |> validate_required([:description, :agent, :agent_listing_code, :listing_url, :image_url])
  end
end
