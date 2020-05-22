defmodule Planatlas.Repo.Migrations.CreateUsersDocuments do
  use Ecto.Migration

  def change do
    create table(:users_documents) do
      add :user_role, :string
      add :document_id, references(:documents, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:users_documents, [:document_id])
    create index(:users_documents, [:user_id])
  end
end
