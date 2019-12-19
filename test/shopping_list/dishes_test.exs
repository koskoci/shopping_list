defmodule ShoppingList.DishesTest do
  use ShoppingList.DataCase

  import ShoppingList.Factory

  alias ShoppingList.Dishes

  describe "dishes" do
    test "list_dishes/0 lists all distinct dishes" do
      flour = insert!(:ingredient)
      salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
      insert!(:item, ingredient_id: flour.id)
      insert!(:item, ingredient_id: salt.id)
      insert!(:item, %{dish: "some other dish", ingredient_id: flour.id})

      assert ["some other dish", "some dish"] = Dishes.list_dishes()
    end

    test "get_dish/1 returns a dish" do
      flour = insert!(:ingredient)
      salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
      insert!(:item, %{dish: "some dish", ingredient_id: salt.id})
      insert!(:item, %{dish: "some dish", ingredient_id: flour.id})

      result = Dishes.get_dish("some dish")
      expected = %{
        name: "some dish",
        items: [
          %{
            ingredient: %{
              name: "flour",
              metric: "grams",
            },
            optional: false,
            quantity: 42,
          },
          %{
            ingredient: %{
              name: "salt",
              metric: "pinches",
            },
            optional: false,
            quantity: 42,
          },
        ],
      }
      assert ^expected = result
    end
  end
end
