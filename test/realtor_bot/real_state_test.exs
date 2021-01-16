defmodule RealtorBot.RealStateTest do
  use RealtorBot.DataCase

  alias RealtorBot.RealState

  describe "description" do
    alias RealtorBot.RealState.Listing

    @valid_attrs %{agent: "some agent", agent_listing_code: "some agent_listing_code", discarded: true, listing_url: "some listing_url"}
    @update_attrs %{agent: "some updated agent", agent_listing_code: "some updated agent_listing_code", discarded: false, listing_url: "some updated listing_url"}
    @invalid_attrs %{agent: nil, agent_listing_code: nil, discarded: nil, listing_url: nil}

    def listing_fixture(attrs \\ %{}) do
      {:ok, listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RealState.create_listing()

      listing
    end

    test "list_description/0 returns all description" do
      listing = listing_fixture()
      assert RealState.list_description() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert RealState.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      assert {:ok, %Listing{} = listing} = RealState.create_listing(@valid_attrs)
      assert listing.agent == "some agent"
      assert listing.agent_listing_code == "some agent_listing_code"
      assert listing.discarded == true
      assert listing.listing_url == "some listing_url"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RealState.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{} = listing} = RealState.update_listing(listing, @update_attrs)
      assert listing.agent == "some updated agent"
      assert listing.agent_listing_code == "some updated agent_listing_code"
      assert listing.discarded == false
      assert listing.listing_url == "some updated listing_url"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = RealState.update_listing(listing, @invalid_attrs)
      assert listing == RealState.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = RealState.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> RealState.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = RealState.change_listing(listing)
    end
  end
end
