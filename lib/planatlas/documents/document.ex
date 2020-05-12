defmodule Planatlas.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Planatlas.Documents.Permalink, autogenerate: true}
  
  schema "documents" do
    field :description, :string
    field :title, :string
    field :slug, :string
    has_many :annotations, Planatlas.Documents.Annotation
    has_many :users_documents, Planatlas.Accounts.UserDocument


    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :slug, slugify(new_title))
      :error -> changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
