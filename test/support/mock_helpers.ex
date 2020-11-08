defmodule SakaVault.Support.MockHelpers do
  @moduledoc false

  import Mox
  import SakaVault.Support.FileHelpers

  alias SakaVault.MockSecretsAPI

  def secrets_mock_fetch(n \\ 1) do
    MockSecretsAPI
    |> expect(:fetch, n, fn _ -> load_json("fetch_secret") end)
  end

  def configure_secrets_mock do
    MockSecretsAPI
    |> expect(:fetch, fn _ -> load_json("fetch_secret") end)
    |> expect(:create, fn _, _ -> load_json("create_secret") end)
  end
end
