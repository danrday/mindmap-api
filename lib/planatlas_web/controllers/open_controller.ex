defmodule PlanatlasWeb.OpenController do
  use PlanatlasWeb, :controller

  alias Planatlas.Documents

  def open(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    render(conn, "open.html", document: document)
  end
end