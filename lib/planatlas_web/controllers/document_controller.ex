defmodule PlanatlasWeb.DocumentController do
  use PlanatlasWeb, :controller

  alias Planatlas.Documents
  alias Planatlas.Documents.Document

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    documents = Documents.list_user_documents(current_user)
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params, _current_user) do
    changeset = Documents.change_document(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params}, current_user) do
    result =
    document_params
    |> Documents.create_document(current_user)
    |> Documents.create_user_document(current_user)

    case result do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: Routes.document_path(conn, :show, document))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    IO.puts("SHOW")
    IO.puts(id)
    document = Documents.get_user_document!(current_user, id)
    render(conn, "show.html", document: document)
  end

  def share(conn, %{"id" => id}, current_user) do
    document = Documents.get_user_document!(current_user, id)
    changeset = Documents.change_document(document)
    render(conn, "share.html", document: document, changeset: changeset)
  end

  def edit(conn, %{"id" => id}, current_user) do
    document = Documents.get_user_document!(current_user, id)
    changeset = Documents.change_document(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}, current_user) do
    document = Documents.get_user_document!(current_user, id)

    case Documents.update_document(document, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: Routes.document_path(conn, :show, document))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    document = Documents.get_user_document!(current_user, id)
    {:ok, _document} = Documents.delete_document(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: Routes.document_path(conn, :index))
  end
end
