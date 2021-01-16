defmodule RealtorBot.RealEstate do
  @moduledoc """
  The RealState context.
  """

  import Ecto.Query, warn: false
  alias RealtorBot.Repo

  alias RealtorBot.RealEstate.Listing

  @doc """
  Returns the list of description.

  ## Examples

      iex> list()
      [%Listing{}, ...]

  """
  def list do
    query =
      from l in Listing,
        order_by: {:asc, l.discarded}

    Repo.all(query)
  end

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

      iex> get_listing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing!(id), do: Repo.get!(Listing, id)

  @doc """
  Creates a listing.

  ## Examples

      iex> create_listing(%{field: value})
      {:ok, %Listing{}}

      iex> create_listing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_listing(attrs \\ %{}) do
    %Listing{}
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a listing.

  ## Examples

      iex> update_listing(listing, %{field: new_value})
      {:ok, %Listing{}}

      iex> update_listing(listing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_listing(%Listing{} = listing, attrs) do
    listing
    |> Listing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a listing.

  ## Examples

      iex> delete_listing(listing)
      {:ok, %Listing{}}

      iex> delete_listing(listing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_listing(%Listing{} = listing) do
    Repo.delete(listing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking listing changes.

  ## Examples

      iex> change_listing(listing)
      %Ecto.Changeset{data: %Listing{}}

  """
  def change_listing(%Listing{} = listing, attrs \\ %{}) do
    Listing.changeset(listing, attrs)
  end

  def upsert_listing(%{agent: agent, agent_listing_code: agent_listing_code} = attrs) do
    Repo.get_by(Listing, agent: agent, agent_listing_code: agent_listing_code)
    |> case do
      nil ->
        %Listing{}
        |> change_listing(attrs)
        |> Repo.insert!()

      listing ->
        listing
        |> change_listing(attrs)
        |> Repo.update!()
    end
  end

  def toggle_listing_discarded(listing_id) do
    listing = Repo.get(Listing, listing_id)

    listing
    |> change_listing(%{discarded: not listing.discarded})
    |> Repo.update!()
  end
end
