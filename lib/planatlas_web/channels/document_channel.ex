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
    IO.puts('after join... calling Presence.list')
    push(socket, "presence_state", PlanatlasWeb.Presence.list(socket))
    {:ok, _} = PlanatlasWeb.Presence.track(
      socket,
      socket.assigns.user_id,
      %{devise: "browser"})
    {:noreply, socket}
  end

  def handle_in(event, params, socket) do
    case event do
      "new_msg" -> 
        handle_in("new_msg", params, nil, socket)
      _ ->
        user = Accounts.get_user!(socket.assigns.user_id)
        handle_in(event, params, user, socket)
    end
   
  end

  def handle_in("new_msg", msg, _user, socket) do
    broadcast!(socket, "server_msg", %{body: msg, user_id: socket.assigns.user_id})
    {:noreply, socket}
  end

  def handle_in("get_user_info", msg, user, socket) do
    {:reply, {:ok, %{"user_id": user.id,
                     "username": user.username,
                     "name": user.name}}, socket}
  end

  # def handle_in("everyone_but_me", msg, _user, socket) do
  #   broadcast_from!(socket, "server_msg", %{body: msg})
  #   {:noreply, socket}
  # end

  def handle_in("get_file", _params, user, socket) do
    document_id = socket.assigns.document_id
    document = Documents.get_user_document!(user, document_id)
    {:reply, {:ok, %{"file": document.file}}, socket}
  end

  def handle_in("save_file", params, user, socket) do
    document_id = socket.assigns.document_id
    document = Documents.save_user_document!(user, document_id, params)
    {:reply, {:ok, %{"file": "SAVED"}}, socket}
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