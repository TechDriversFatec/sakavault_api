defmodule SakaVaultWeb.Router do
  use SakaVaultWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SakaVaultWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", AuthController, :register
  end
end
