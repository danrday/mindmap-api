defmodule PlanatlasWeb.OpenController do
  use PlanatlasWeb, :controller

  alias Planatlas.Documents

  def open(conn, %{"id" => id}) do

    document = Documents.get_document!(id)

    conn
    |> put_layout(false)
    |> render("open.html", document: document)
  end
end