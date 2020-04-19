defmodule Planatlas.Documents.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotations" do
    field :at, :utc_datetime
    field :body, :string

    belongs_to :user, Planatlas.Accounts.User
    belongs_to :document, Planatlas.Documents.Document

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
