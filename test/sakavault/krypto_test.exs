defmodule SakaVault.KryptoTest do
  use SakaVault.DataCase

  alias SakaVault.Accounts.User
  alias SakaVault.Krypto

  @valid_attrs %{
    name: "Max",
    email: "max@example.com",
    password: "NoCarbsBeforeMarbs"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    assert {:ok, %User{}} = @valid_attrs
                            |> User.changeset()
                            |> Krypto.insert()
  end
end
