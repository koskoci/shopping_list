defmodule ShoppingListWeb.DishView do
  use ShoppingListWeb, :view

  alias ShoppingList.Recipes.Item
  alias ShoppingList.Dishes
  alias ShoppingList.Dishes.Dish

  def list(ingredients) do
    ingredients
    |> Enum.map(&({"#{&1.metric} of #{&1.name}", &1.id}))
  end

  def link_to_item_fields(ingredients) do
    changeset = Dishes.change_dish(%Dish{items: [%Item{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "item_fields.html", f: form, ingredients: ingredients)
    link "Add Item", to: "#", "data-template": fields, id: "add_item"
  end
end
