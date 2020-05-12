defmodule Planatlas.Repo.Migrations.CreateAnnotations do
  use Ecto.Migration

  def change do
    create table(:annotations) do
      add :body, :text
      add :at, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)
      add :document_id, references(:documents, on_delete: :delete_all)

      timestamps()
    end

    create index(:annotations, [:user_id])
    create index(:annotations, [:document_id])
  end
end
