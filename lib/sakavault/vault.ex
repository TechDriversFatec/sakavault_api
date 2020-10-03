defmodule SakaVault.Vault do
  @moduledoc false

  alias SakaVault.{
    Accounts.User,
    Repo,
    Vault.Secret
  }

  import Ecto.Query

  def all(%User{} = user) do
    Secret
    |> where([s], s.user_id == ^user.id)
    |> Repo.all()
  end

  def find(id), do: {:ok, Repo.get(Secret, id)}

  def create(attrs, %User{id: user_id}) do
    attrs
    |> Map.put(:user_id, user_id)
    |> Secret.changeset()
    |> Repo.insert()
  end

  def update(secret, attrs) do
    secret
    |> Secret.changeset(attrs)
    |> Repo.update()
  end

  def delete(secret), do: Repo.delete(secret)
end
