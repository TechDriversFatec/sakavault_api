defmodule SakaVault.Support.Factories do
  @moduledoc false

  use ExMachina.Ecto, repo: SakaVault.Repo

  alias Faker.Person.PtBr, as: Brazilian

  alias SakaVault.{
    Accounts.User,
    Fields.Hash,
    Vault.Secret
  }

  def user_factory do
    name = Brazilian.name()

    email =
      name
      |> String.downcase()
      |> String.replace(~r/[^a-zA-Z]/, "")

    email = "#{email}@#{Faker.Internet.free_email_service()}"

    %User{
      name: name,
      email: email,
      password: name,
      password_hash: name,
      email_hash: Hash.hash(email)
    }
  end

  def secret_factory do
    %Secret{
      name: "website",
      username: "username",
      password: "password",
      user: insert(:user)
    }
  end
end
