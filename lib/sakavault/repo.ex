defmodule SakaVault.Repo do
  use Ecto.Repo,
    otp_app: :sakavault,
    adapter: Ecto.Adapters.Postgres
end
