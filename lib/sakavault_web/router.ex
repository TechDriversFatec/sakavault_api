defmodule SakaVaultWeb.Router do
  use SakaVaultWeb, :router

  pipeline :cors do
    plug(Corsica,
      origins: [
        ~r{^https?:\/\/0.0.0.0:\d+$},
        ~r{^https?:\/\/127.0.0.1:\d+$},
        ~r{^https?:\/\/localhost:\d+$},
        ~r{^https:\/\/sakavault\.netlify\.app/$}
      ],
      allow_headers: ~w(
            accept
            authorization
            content-type
            access-control-allow-methods
            access-control-allow-origin
          ),
      max_age: 86_400,
      allow_credentials: true
    )
  end

  pipe_through :cors

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug SakaVaultWeb.Guardian.AuthPipeline
  end

  scope "/api", SakaVaultWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", AuthController, :register

    pipe_through :auth

    get "/account", AccountController, :show
    # patch "/account", AccountController, :update
    # delete "/account", AccountController, :delete

    resources "/secrets", VaultController, except: [:new, :edit]
  end
end
