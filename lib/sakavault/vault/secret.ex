defmodule SakaVault.Vault.Secret do
  @moduledoc false

  use SakaVault.Schema

  alias SakaVault.Accounts.User
  alias SakaVault.Fields.Encrypted

  schema "secrets" do
    field :name, Encrypted
    field :username, Encrypted
    field :password, Encrypted

    belongs_to :user, User

    timestamps()
  end

  def changeset(%__MODULE__{} = secret, params) do
    user
    |> cast(params, [:user_id, :name, :username, :password])
    |> validate_required([:user_id, :name, :username, :password])
    |> add_email_hash()
    |> add_password_hash()
    |> foreign_key_constraint(:user_id)
  end
end
