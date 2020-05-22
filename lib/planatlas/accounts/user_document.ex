defmodule Planatlas.Accounts.UserDocument do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_documents" do
    field :user_role, :string
    belongs_to :user, Planatlas.Accounts.User
    belongs_to :document, Planatlas.Documents.Document

    timestamps()
  end

  @doc false
  def changeset(user_document, attrs) do
    user_document
    |> cast(attrs, [:user_role])
    |> validate_required([:user_role])
  end
end
