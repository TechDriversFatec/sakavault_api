defmodule SakaVault.Secrets do
  @moduledoc false

  def fetch(secret_id) do
    {:ok, %{"SecretString" => secret_key}} = secrets_api().fetch(secret_id)

    {:ok, secret_key}
  end

  def create(secret_id, secret_key) do
    secrets_api().create(secret_id, secret_key)
  end

  def delete(secret_id) do
    secrets_api().delete(secret_id)
  end

  def delete_all do
    {:ok, %{"SecretList" => secrets}} = secrets_api().list()

    secrets
    |> Enum.map(& &1["Name"])
    |> Enum.each(&delete/1)
  end

  def secrets_api, do: Application.get_env(:sakavault, :secrets_api)
end
