defmodule ShoppingList.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:ingredients) do
      add :name, :citext
      add :metric, :string

      timestamps()
    end

    create unique_index(:ingredients, [:name])
  end

  def down do
    drop index(:ingredients, [:name])
    drop table(:ingredients)
  end
end
