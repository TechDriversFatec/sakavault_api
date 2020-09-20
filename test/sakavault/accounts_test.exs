defmodule SakaVault.AccountsTest do
  use SakaVault.DataCase

  alias SakaVault.Accounts

  alias SakaVault.Accounts.User

  describe "find/1" do
    setup do
      {:ok, user} =
        %{
          name: "John Doe",
          email: "john@doe.com",
          password: "johndoe123"
        }
        |> Accounts.create()

      {:ok, user: user}
    end

    test "with valid id", %{user: user} do
      assert {:ok, %User{} = user} = Accounts.find(user.id)

      assert user.name == "John Doe"
    end

    test "with invalid id" do
      assert {:ok, nil} = Accounts.find(Ecto.UUID.generate())
    end
  end

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
