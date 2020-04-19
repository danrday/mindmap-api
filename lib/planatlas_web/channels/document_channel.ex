defmodule PlanatlasWeb.DocumentChannel do
  use PlanatlasWeb, :channel

  alias Planatlas.{Accounts, Documents}
  alias PlanatlasWeb.AnnotationView

  # def join("documents:" <> document_id, _params, socket) do
  #   {:ok, assign(socket, :document_id, String.to_integer(document_id))}
  # end

  def join("documents:" <> document_id, params, socket) do
    send(self(), :after_join)
    last_seen_id = params["last_seen_id"] || 0
    document_id = String.to_integer(document_id)
    document = Documents.get_document!(document_id)

    annotations =
      document
      |> Documents.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :document_id, document_id)}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", PlanatlasWeb.Presence.list(socket))
    {:ok, _} = PlanatlasWeb.Presence.track(
      socket,
      socket.assigns.user_id,
      %{devise: "browser"})
    {:noreply, socket}
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