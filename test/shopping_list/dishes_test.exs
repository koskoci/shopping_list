defmodule ShoppingList.DishesTest do
  use ShoppingList.DataCase

  import ShoppingList.Factory

  alias ShoppingList.Dishes
  alias ShoppingList.Recipes.Ingredient

  describe "dishes" do
    test "list_dishes/0 lists all distinct dishes" do
      flour = insert!(:ingredient)
      salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
      insert!(:item, ingredient_id: flour.id)
      insert!(:item, ingredient_id: salt.id)
      insert!(:item, %{dish: "some other dish", ingredient_id: flour.id})

      assert ["some other dish", "some dish"] = Dishes.list_dishes()
    end
  end
end
