defmodule SakaVault.SecretsBehaviour do
  @moduledoc false

  @callback list :: list()

  @callback fetch(binary()) :: {:ok, binary()} | {:error, any()}
  @callback create(binary(), binary()) :: {:ok, any()} | {:error, any()}

  @callback delete(map()) :: {:ok, any()} | {:error, any()}
  @callback delete(binary()) :: {:ok, any()} | {:error, any()}
end
