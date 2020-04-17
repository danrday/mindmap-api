defmodule Planatlas.Repo.Migrations.CreateUserDocuments do
  use Ecto.Migration

  def change do
    create table(:user_documents) do
      add :user_role, :string
      add :document_id, references(:documents, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_documents, [:document_id])
    create index(:user_documents, [:user_id])
  end
end
