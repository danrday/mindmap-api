defmodule PlanatlasWeb.Router do
  use PlanatlasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlanatlasWeb do
    pipe_through :browser

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    get "/", PageController, :index
  end
end
