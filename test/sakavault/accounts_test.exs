defmodule SakaVault.AccountsTest do
  use SakaVault.DataCase

  alias SakaVault.Accounts

  alias SakaVault.Accounts.User

  describe "create/1" do
    test "with valid data creates a user" do
      attrs = %{
        name: "John Doe",
        email: "john@doe.com",
        password: "johndoe123"
      }

      assert {:ok, %User{} = user} = Accounts.create(attrs)

      assert user.name == "John Doe"
    end

    test "invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create(%{name: "John Doe"})
    end
  end
end
