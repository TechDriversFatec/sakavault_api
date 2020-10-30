ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SakaVault.Repo, :manual)

Mox.defmock(SakaVault.MockSecrets, for: SakaVault.SecretsBehaviour)
