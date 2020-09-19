defmodule SakaVaultWeb.Router do
  use SakaVaultWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SakaVaultWeb do
    pipe_through :api
  end
end
