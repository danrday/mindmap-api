defmodule Planatlas.Repo.Migrations.AddSlugToDocuments do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :slug, :string
    end
  end
end
