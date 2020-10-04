defmodule SakaVaultWeb.VaultControllerTest do
  use SakaVaultWeb.ConnCase

  alias SakaVault.Vault.Secret

  setup %{conn: conn} do
    user = insert(:user)

    secret1 = insert(:secret, user: user)
    secret2 = insert(:secret, user: user)

    secret_params = %{name: "website", username: "john@doe.com", password: "johndoe123"}

    {
      :ok,
      user: user,
      secret1: secret1,
      secret2: secret2,
      secret_params: secret_params,
      conn: put_req_header(conn, "accept", "application/json")
    }
  end

  describe "GET /index" do
    test "returns error if user not authenticated", %{conn: conn} do
      assert %{"errors" => errors} =
               conn
               |> get(Routes.vault_path(conn, :index))
               |> json_response(401)

      assert %{"detail" => "unauthenticated"} = errors
    end

    test "returns error if invalid token is used", %{conn: conn} do
      assert %{"errors" => errors} =
               conn
               |> put_req_header("authorization", "Bearer invalid_token")
               |> get(Routes.vault_path(conn, :index))
               |> json_response(401)

      assert %{"detail" => "invalid_token"} = errors
    end

    test "returns user' secrets", %{
      conn: conn,
      user: user,
      secret1: %{id: secret1_id},
      secret2: %{id: secret2_id}
    } do
      assert response =
               conn
               |> put_authorization(user)
               |> get(Routes.vault_path(conn, :index))
               |> json_response(200)

      assert %{"data" => [%{"id" => ^secret1_id}, %{"id" => ^secret2_id}]} = response
    end
  end

  describe "GET /show" do
    test "returns error if user not authenticated", %{conn: conn, secret1: secret} do
      assert %{"errors" => errors} =
               conn
               |> get(Routes.vault_path(conn, :show, secret))
               |> json_response(401)

      assert %{"detail" => "unauthenticated"} = errors
    end

    test "returns error if invalid token is used", %{conn: conn, secret1: secret} do
      assert %{"errors" => errors} =
               conn
               |> put_req_header("authorization", "Bearer invalid_token")
               |> get(Routes.vault_path(conn, :show, secret))
               |> json_response(401)

      assert %{"detail" => "invalid_token"} = errors
    end

    test "return invalid secrets", %{conn: conn, user: user} do
      assert response =
               conn
               |> put_authorization(user)
               |> get(Routes.vault_path(conn, :show, %Secret{id: Ecto.UUID.generate()}))
               |> json_response(200)

      assert %{"data" => nil} == response
    end

    test "returns user' secrets", %{conn: conn, user: user, secret1: secret} do
      assert response =
               conn
               |> put_authorization(user)
               |> get(Routes.vault_path(conn, :show, secret))
               |> json_response(200)

      assert %{
               "data" => %{
                 "id" => secret.id,
                 "name" => secret.name,
                 "username" => secret.username,
                 "password" => secret.password,
                 "notes" => secret.notes
               }
             } == response
    end
  end

  describe "POST /create" do
    test "returns error if user not authenticated", %{conn: conn, secret_params: params} do
      assert %{"errors" => errors} =
               conn
               |> post(Routes.vault_path(conn, :create, params))
               |> json_response(401)

      assert %{"detail" => "unauthenticated"} = errors
    end

    test "returns error if invalid token is used", %{conn: conn, secret_params: params} do
      assert %{"errors" => errors} =
               conn
               |> put_req_header("authorization", "Bearer invalid_token")
               |> post(Routes.vault_path(conn, :create, params))
               |> json_response(401)

      assert %{"detail" => "invalid_token"} = errors
    end

    test "returns secret validation errors", %{conn: conn, user: user} do
      assert response =
               conn
               |> put_authorization(user)
               |> post(Routes.vault_path(conn, :create, %{name: "website", username: "john"}))
               |> json_response(422)

      assert %{
               "errors" => %{
                 "password" => ["can't be blank"]
               }
             } = response
    end

    test "returns created secret", %{conn: conn, user: user, secret_params: params} do
      assert response =
               conn
               |> put_authorization(user)
               |> post(Routes.vault_path(conn, :create, params))
               |> json_response(200)

      assert %{
               "data" => %{
                 "name" => "website",
                 "username" => "john@doe.com",
                 "password" => "johndoe123",
                 "notes" => nil
               }
             } = response
    end
  end
end
