defmodule PlanatlasWeb.Router do
  use PlanatlasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlanatlasWeb.Auth #q: how does it know to look in controllers/auth.ex? automagic?
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlanatlasWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    # resources "/documents", DocumentController
  end

  scope "/manage", PlanatlasWeb do
    pipe_through [:browser, :authenticate_user]
  
    get "/documents/:id/share", DocumentController, :share, as: :share

    resources "/documents", DocumentController
  end
end
