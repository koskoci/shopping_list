defmodule ShoppingList.TalliesTest do
  use ShoppingList.DataCase

  alias ShoppingList.Recipes

  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{name: "flour", metric: "grams"})
      |> Recipes.create_ingredient()

    ingredient
  end

  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{dish: "some dish", optional: true, quantity: 42, ingredient_id: nil})
      |> Recipes.create_item()

    item
  end

  test "create_list/1 returns an ordered shopping list" do
    flour = ingredient_fixture()
    salt = ingredient_fixture(%{name: "salt", metric: "pinches"})
    item_fixture(%{dish: "some dish", ingredient_id: salt.id, quantity: 5})
    item_fixture(%{dish: "some dish", ingredient_id: flour.id})
    item_fixture(%{dish: "some other dish", ingredient_id: flour.id})
    item_fixture(%{dish: "yet another dish", ingredient_id: flour.id, quantity: 1000})

    result = ShoppingList.Tallies.create_list(["some dish", "some other dish"])
    expected = %{
      items: [
        %{
          quantity: 84,
          ingredient: %{
            name: "flour",
            metric: "grams",
          },
        },
        %{
          quantity: 5,
          ingredient: %{
            name: "salt",
            metric: "pinches",
          },
        },
      ]
    }
    assert ^expected = result
  end
end
