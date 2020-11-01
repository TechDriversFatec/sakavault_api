defmodule SakaVault.Krypto do
  @moduledoc false

  @ignorable_fields ~w(id inserted_at updated_at)
  @ignorable_field_regex ~r/(_id|_hash)$/

  alias Ecto.Changeset
  alias SakaVault.Accounts
  alias SakaVault.AES

  def decrypt(struct) do
    {:ok, user} =
      struct
      |> Map.get(:user_id)
      |> case do
        nil -> Map.get(struct, :id)
        user_id -> user_id
      end
      |> Accounts.find()

    {:ok, secret_key} =
      user
      |> secret_id()
      |> secrets().fetch()

    fields = get_fields(struct)

    Enum.reduce(fields, struct, fn field, acc_struct ->
      decrypted_value =
        struct
        |> Map.get(field)
        |> decrypt_value(secret_key)

      %{acc_struct | field => decrypted_value}
    end)
  end

  def encrypt(%{valid?: false} = changeset), do: changeset

  def encrypt(%{data: data, changes: changes} = changeset) do
    fields = get_fields(data)

    {:ok, secret_key} =
      changes
      |> secret_id()
      |> secrets().fetch()

    Enum.reduce(fields, changeset, fn field, acc_changeset ->
      encrypted_value =
        changeset
        |> Changeset.get_change(field)
        |> encrypt_value(secret_key)

      Changeset.put_change(acc_changeset, field, encrypted_value)
    end)
  end

  defp decrypt_value(nil, _), do: nil
  defp decrypt_value(value, key), do: AES.decrypt(value, key)

  defp encrypt_value(nil, _), do: nil
  defp encrypt_value(value, key), do: AES.encrypt(value, key)

  def hash_value(value), do: salt(value)

  def password_value(password) do
    Argon2.Base.hash_password(password, Argon2.gen_salt(), argon2_type: 2)
  end

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

  def secret_id(%{email_hash: email_hash, password_hash: password_hash}) do
    [email_hash, password_hash]
    |> Enum.join("")
    |> salt()
    |> Base.encode16()
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

  defp secrets do
    Application.get_env(:sakavault, :secrets)
  end
end
