defmodule PlanatlasWeb.UserView do
	use PlanatlasWeb, :view
	alias Planatlas.Accounts

	def first_name(%Accounts.User{name: name}) do
		name
		|> String.split(" ")
		|> Enum.at(0)
	end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end

end