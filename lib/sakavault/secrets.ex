defmodule SakaVault.Secrets do
  @moduledoc false

  @behaviour SakaVault.SecretsBehaviour

  alias ExAws.SecretsManager

  def list do
    SecretsManager.list_secrets() |> ExAws.request()
  end

  def fetch(secret_id) do
    {:ok, %{"SecretString" => secret_key}} =
      "sakavault/#{secret_id}"
      |> SecretsManager.get_secret_value()
      |> ExAws.request()

    {:ok, secret_key}
  end

  def create(secret_id, secret_key) do
    opts = %{
      "SecretString" => secret_key,
      "Name" => "sakavault/" <> secret_id,
      "ClientRequestToken" => Ecto.UUID.generate()
    }

    opts
    |> SecretsManager.create_secret()
    |> ExAws.request()
  end

  def delete(%{id: user_id}) do
    "sakavault/#{user_id}"
    |> SecretsManager.delete_secret()
    |> ExAws.request()
  end

  def delete(secret_id) do
    secret_id
    |> SecretsManager.delete_secret()
    |> ExAws.request()
  end

  def delete_all do
    {:ok, %{"SecretList" => list}} = list()

    list
    |> Enum.map(& &1["Name"])
    |> Enum.each(&delete/1)
  end
end
