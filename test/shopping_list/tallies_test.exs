defmodule ShoppingList.TalliesTest do
  use ShoppingList.DataCase

  import ShoppingList.Factory

  test "create_list/1 returns an ordered shopping list" do
    flour = insert!(:ingredient)
    salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
    insert!(:item, %{dish: "some dish", ingredient_id: salt.id, quantity: 5})
    insert!(:item, %{dish: "some dish", ingredient_id: flour.id})
    insert!(:item, %{dish: "some other dish", ingredient_id: flour.id})
    insert!(:item, %{dish: "yet another dish", ingredient_id: flour.id, quantity: 1000})

    result = ShoppingList.Tallies.create_list(["some dish", "some other dish"])
    expected = %{
      items: [
        %{
          ingredient: %{
            name: "flour",
            metric: "grams",
          },
          optional: false,
          quantity: 84,
        },
        %{
          ingredient: %{
            name: "salt",
            metric: "pinches",
          },
          optional: false,
          quantity: 5,
        },
      ]
    }
    assert ^expected = result
  end
end
