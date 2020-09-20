defmodule SakaVault.Accounts.User do
  @moduledoc false

  use SakaVault.Schema

  schema "users" do
    field :name, :binary
    field :email, :binary
    field :email_hash, :binary
    field :password_hash, :binary

    timestamps()
  end

  def changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, [:name, :email, :email_hash, :password_hash])
    |> validate_required([:name, :email, :email_hash, :password_hash])
    |> unique_constraint(:email_hash)
  end
end
