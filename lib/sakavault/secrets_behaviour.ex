defmodule SakaVault.SecretsBehaviour do
  @callback list :: list()

  @callback create_key(map()) :: {:ok, any()} | {:error, any()}

  @callback delete_key(map()) :: {:ok, any()} | {:error, any()}
  @callback delete_key(binary()) :: {:ok, any()} | {:error, any()}
end
