defmodule RealtorBot.Repo.Migrations.AddImageUrlToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :image_url, :string
    end
  end
end
