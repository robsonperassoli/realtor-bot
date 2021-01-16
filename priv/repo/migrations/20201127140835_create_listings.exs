defmodule RealtorBot.Repo.Migrations.CreateDescription do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :description, :string
      add :agent, :string
      add :agent_listing_code, :string
      add :listing_url, :string
      add :discarded, :boolean, default: false, null: false

      timestamps()
    end

  end
end
