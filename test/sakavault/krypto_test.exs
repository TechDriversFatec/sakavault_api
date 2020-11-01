defmodule SakaVault.KryptoTest do
  use SakaVault.DataCase

  alias SakaVault.Accounts.User
  alias SakaVault.{Krypto, Repo}

  @valid_attrs %{
    name: "Max",
    email: "max@example.com",
    password: "NoCarbsBeforeMarbs"
  }

  describe "secret_id" do
    test "always produces the same secret_id for the same user" do
      %{changes: user} = User.changeset(@valid_attrs)

      assert Krypto.secret_id(user) == Krypto.secret_id(user)
    end

    test "never produces the same secret_id for different users" do
      %{changes: user1} = User.changeset(%{@valid_attrs | password: "nopass123"})
      %{changes: user2} = User.changeset(%{@valid_attrs | password: "nopass100"})

      refute Krypto.secret_id(user1) == Krypto.secret_id(user2)
    end
  end

  describe "salt" do
    test "always produces the same salt for the same value" do
      assert Krypto.salt("value") == Krypto.salt("value")
    end

    test "never produces the same salt for different values" do
      refute Krypto.salt("value0") == Krypto.salt("value1")
    end
  end

  describe "secret_key" do
    test "always produces the same secret_key for the same value" do
      assert Krypto.secret_key("value") == Krypto.secret_key("value")
    end

    test "never produces the same secret_key for different values" do
      refute Krypto.secret_key("value0") == Krypto.secret_key("value1")
    end
  end

  describe "encrypt" do
    test "return raw changeset when invalid" do
      assert {:error, %Ecto.Changeset{} = user} =
               %{}
               |> User.changeset()
               |> Krypto.encrypt()
               |> Repo.insert()
    end

    test "encrypt changeset with valid attributes" do
      secrets_mock_fetch()

      assert {:ok, %User{} = user} =
               @valid_attrs
               |> User.changeset()
               |> Krypto.encrypt()
               |> Repo.insert()

      refute user.name == @valid_attrs[:name]
      refute user.email == @valid_attrs[:email]
    end
  end

  describe "decrypt" do
    test "user from database" do
      secrets_mock_fetch()

      assert {:ok, %User{id: user_id}} =
               @valid_attrs
               |> User.changeset()
               |> Krypto.encrypt()
               |> Repo.insert()

      secrets_mock_fetch()

      user =
        User
        |> Repo.get(user_id)
        |> Krypto.decrypt()

      assert user.name == @valid_attrs[:name]
      assert user.email == @valid_attrs[:email]
    end
  end
end
