defmodule ShoppingList.Recipes.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :optional, :boolean, default: false
    field :quantity, :integer
    belongs_to :ingredient, ShoppingList.Recipes.Ingredient
    belongs_to :dish, ShoppingList.Dishes.Dish

    timestamps()
  end

    @allowed_fields [:optional, :quantity, :ingredient_id, :dish_id]
    @required_fields [:optional, :quantity]

  def changeset(item, attrs) do
    item
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:ingredient, name: :items_ingredient_id_fkey)
  end
end
