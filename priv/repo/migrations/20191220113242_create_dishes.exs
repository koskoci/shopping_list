defmodule ShoppingList.Repo.Migrations.CreateDishes do
  use Ecto.Migration

  def up do
    create table(:dishes) do
      add :name, :string

      timestamps()
    end

    create unique_index(:dishes, [:name])
  end

  def down do
    drop index(:dishes, [:name])
    drop table(:dishes)
  end
end
