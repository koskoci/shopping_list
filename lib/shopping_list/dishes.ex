defmodule ShoppingList.Dishes do
  import Ecto.Query, warn: false

  alias ShoppingList.Repo
  alias ShoppingList.Recipes.Item
  alias ShoppingList.Recipes.Ingredient

  def get_dish(name) do
    query = from item in Item,
      join: ingredient in Ingredient,
      on: item.ingredient_id == ingredient.id,
      where: item.dish == ^name,
      order_by: [item.optional, ingredient.name],
      select: %{
        quantity: item.quantity,
        ingredient: %{
          name: ingredient.name,
          metric: ingredient.metric,
        },
        optional: item.optional,
      }

    %{
      name: name,
      items: query |> Repo.all,
    }
  end

  def list_dishes do
    from(i in Item, distinct: true, select: i.dish)
    |> Repo.all
  end
end
