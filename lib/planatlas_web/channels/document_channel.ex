defmodule PlanatlasWeb.DocumentChannel do
  use PlanatlasWeb, :channel

  # def join("documents:" <> document_id, _params, socket) do
  #   {:ok, assign(socket, :document_id, String.to_integer(document_id))}
  # end

  def join("documents:" <> document_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_annotation", params, socket) do
    broadcast!(socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    })

    {:reply, :ok, socket}
  end
end