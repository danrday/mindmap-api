defmodule Planatlas.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :description, :text

      timestamps()
    end

  end
end
