defmodule ShoppingList.Tallies do
  import Ecto.Query, warn: false

  alias ShoppingList.Repo
  alias ShoppingList.Recipes.Ingredient
  alias ShoppingList.Recipes.Item

  def create_list(dishes) do
    query = from item in Item,
      join: ingredient in Ingredient,
      on: item.ingredient_id == ingredient.id,
      where: item.dish in ^dishes,
      group_by: [ingredient.name, ingredient.metric],
      order_by: [ingredient.name],
      select: %{
        quantity: sum(item.quantity),
        ingredient: %{
          name: ingredient.name,
          metric: ingredient.metric,
        },
      }

    %{
      items: Repo.all(query)
    }
  end
end
