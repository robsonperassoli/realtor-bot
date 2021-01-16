defmodule RealtorBot.Repo do
  use Ecto.Repo,
    otp_app: :realtor_bot,
    adapter: Ecto.Adapters.Postgres
end
