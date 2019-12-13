defmodule ShoppingList.Recipes.List do
  use Ecto.Schema

  schema "lists" do
    has_many :items, ShoppingList.Recipes.Item
  end
end
