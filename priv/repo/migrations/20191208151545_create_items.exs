defmodule ShoppingList.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :quantity, :integer
      add :optional, :boolean, default: false, null: false
      add :dish, :string
      add :ingredient_id, references(:ingredients, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:ingredient_id])
  end
end
