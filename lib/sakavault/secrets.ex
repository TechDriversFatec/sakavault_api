defmodule SakaVault.Secrets do
  @moduledoc false

  alias ExAws.SecretsManager
  alias SakaVault.Accounts.User

  def list do
    SecretsManager.list_secrets() |> ExAws.request()
  end

  def create_key(%{id: user_id, password_hash: password}) do
    opts = %{
      "Name" => "sakavault/" <> user_id,
      "SecretString" => "#{user_id}|#{password}",
      "ClientRequestToken" => Ecto.UUID.generate()
    }

    opts
    |> SecretsManager.create_secret()
    |> ExAws.request()
  end

  def delete_key(%{id: user_id}) do
    "sakavault/#{user_id}"
    |> SecretsManager.delete_secret()
    |> ExAws.request()
  end

  def delete_key(secret_id) do
    secret_id
    |> SecretsManager.delete_secret()
    |> ExAws.request()
  end

  def delete_all do
    {:ok, %{"SecretList" => list}} = list()

    list
    |> Enum.map(& &1["Name"])
    |> Enum.each(&delete_key/1)
  end
end
