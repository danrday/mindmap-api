defmodule PlanatlasWeb.PageController do
  use PlanatlasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
