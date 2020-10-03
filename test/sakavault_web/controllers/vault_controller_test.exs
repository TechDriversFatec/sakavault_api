defmodule SakaVaultWeb.VaultControllerTest do
  use SakaVaultWeb.ConnCase

  setup %{conn: conn} do
    user = insert(:user)

    secret1 = insert(:secret, user: user)
    secret2 = insert(:secret, user: user)

    {
      :ok,
      user: user,
      secret1: secret1,
      secret2: secret2,
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
end
