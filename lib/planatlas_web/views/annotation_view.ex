defmodule PlanatlasWeb.AnnotationView do
  use PlanatlasWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, PlanatlasWeb.UserView, "user.json")
    }
  end
end