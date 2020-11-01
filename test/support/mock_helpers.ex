defmodule SakaVault.Support.MockHelpers do
  @moduledoc false

  import Mox
  import SakaVault.Support.FileHelpers

  alias SakaVault.MockSecrets

  # @secret_id "9657BE9C20C3FD78C9BE413EB44CBC8B3E36E56CF6920E6C2C5D3CA5384932D2"
  @secret_key "DGqS0IGsvpe/gEx63Cm4BH35px0dqgRZmX8DiLbCU+U="

  def secrets_mock_fetch(n \\ 1) do
    MockSecrets
    |> expect(:fetch, n, fn _ -> {:ok, @secret_key} end)
  end

  def configure_secrets_mock do
    MockSecrets
    |> expect(:fetch, fn _ -> {:ok, @secret_key} end)
    |> expect(:create, fn _, _ -> load_json("create_secret") end)
  end
end
