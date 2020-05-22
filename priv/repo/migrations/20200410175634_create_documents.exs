defmodule Planatlas.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :description, :text
      add :file, :jsonb

      timestamps()
    end

  end
end
