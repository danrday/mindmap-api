defmodule Planatlas.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :description, :text

      timestamps()
    end

    create table(:user_documents) do
      add :document_id, references(:documents)
      add :user_id, references(:users)
      add :user_role, :string

      timestamps()
    end

  end
end
