defmodule ShoppingList.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :quantity, :integer
      add :optional, :boolean, default: false, null: false
      add :ingredient_id, references(:ingredients, on_delete: :nothing)
      add :dish_id, references(:dishes, on_delete: :delete_all)

      timestamps()
    end

    create index(:items, [:ingredient_id])
    create index(:items, [:dish_id])
  end
end
