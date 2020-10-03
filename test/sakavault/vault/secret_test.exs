defmodule SakaVault.Vault.SecretTest do
  use SakaVault.DataCase

  alias SakaVault.Vault.Secret

  @valid_attrs %{
    name: "JohnWebsite",
    username: "johndoe",
    password: "johnpass123"
  }

  setup do
    %{user: insert(:user)}
  end

  test "changeset with valid attributes", %{user: user} do
    assert %{valid?: true} = @valid_attrs
                             |> Map.merge(%{user_id: user.id})
                             |> Secret.changeset()
  end

  test "changeset with valid attributes and invalid user" do
    assert {:error, %{valid?: false}} = @valid_attrs
                                        |> Map.merge(%{user_id: Ecto.UUID.generate()})
                                        |> Secret.changeset()
                                        |> Repo.insert()
  end

  test "changeset with invalid attributes", %{user: user} do
    assert %{valid?: false} = Secret.changeset(%{user_id: user.id})
  end
end
