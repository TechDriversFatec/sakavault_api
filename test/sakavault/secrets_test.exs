defmodule SakaVault.SecretsTest do
  use SakaVault.DataCase

  alias SakaVault.MockSecrets

  setup do
    %{secrets: Application.get_env(:sakavault, :secrets)}
  end

  describe "list" do
    test "list all secrets", %{secrets: secrets} do
      expect(MockSecrets, :list, fn -> load_json("list_secrets") end)

      assert {:ok, %{"SecretList" => [_ | _]}} = secrets.list()
    end
  end

  describe "create" do
    test "create a secret", %{secrets: secrets} do
      expect(MockSecrets, :create, fn _, _ -> load_json("create_secret") end)

      assert {:ok, %{"ARN" => _, "Name" => _, "VersionId" => _}} =
               secrets.create("secret_id", "secret_key")
    end
  end

  describe "fetch" do
    test "fetch secret", %{secrets: secrets} do
      expect(MockSecrets, :fetch, fn _ -> load_json("fetch_secret") end)

      assert {:ok, _} = secrets.fetch("secret_id")
    end
  end
end
