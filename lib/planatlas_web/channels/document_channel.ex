defmodule PlanatlasWeb.DocumentChannel do
  use PlanatlasWeb, :channel

  alias Planatlas.{Accounts, Documents}

  # def join("documents:" <> document_id, _params, socket) do
  #   {:ok, assign(socket, :document_id, String.to_integer(document_id))}
  # end

  def join("documents:" <> document_id, _params, socket) do
    {:ok, assign(socket, :document_id, String.to_integer(document_id))}
  end

  def handle_in(event, params, socket) do
    user = Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    case Documents.annotate_document(user, socket.assigns.document_id, params) do
      {:ok, annotation} -> 
        broadcast!(socket, "new_annotation", %{
        id: annotation.id,
        user: PlanatlasWeb.UserView.render("user.json", %{user: user}),
        body: annotation.body,
        at: annotation.at
      })
      {:reply, :ok, socket}

      {:error, changeset} -> 
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end