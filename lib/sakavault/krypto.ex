defmodule SakaVault.Krypto do
  @moduledoc false

  @ignorable_fields ~w(id inserted_at updated_at)
  @ignorable_field_regex ~r/_hash$/

  alias Ecto.Changeset

  def encrypt(struct_or_changeset) do
    # secret_key = secret_key(user.password)

    # fields = get_fields(data)

    # encrypted_changes =
    #   Enum.reduce(fields, struct_or_changeset, fn {key, value}, acc ->
    #     value = encrypt_value(value, secret_key)

    #     Map.put(acc, key, value)
    #   end)

    # Map.put(changeset, :changes, encrypted_changes)
  end

  defp encrypt_value(value, key), do: AES.encrypt(value, key)

  defp get_fields(%{__struct__: schema}) do
    :fields
    |> schema.__schema__()
    |> Enum.reject(&ignorable_field/1)
  end

  defp ignorable_field(field) when not is_binary(field) do
    field
    |> to_string()
    |> ignorable_field()
  end

  defp ignorable_field(field) do
    field in @ignorable_fields or field =~ @ignorable_field_regex
  end

  def salt(value) do
    :crypto.hash(:sha256, value <> secret_key_base())
  end

  def secret_key(key) do
    :sha256
    |> :crypto.hash(key <> secret_key_base())
    |> :base64.encode()
  end

  defp secret_key_base do
    :sakavault
    |> Application.get_env(SakaVaultWeb.Endpoint)
    |> Keyword.get(:secret_key_base)
  end
end
