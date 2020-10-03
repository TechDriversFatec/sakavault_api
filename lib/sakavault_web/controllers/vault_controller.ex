defmodule SakaVaultWeb.VaultController do
  use SakaVaultWeb, :controller

  action_fallback SakaVaultWeb.FallbackController

  alias SakaVault.Vault

  def action(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, user]
    )
  end

  def index(conn, _params, user) do
    secrets = Vault.all(user)

    render(conn, "index.json", secrets: secrets)
  end

  def show(conn, params, _user) do
    {:ok, secret} = Vault.find(params["id"])

    render(conn, "show.json", %{secret: secret})
  end
end
