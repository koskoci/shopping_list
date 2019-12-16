defmodule ShoppingList.Tallies do

  import Ecto.Query, warn: false

  alias ShoppingList.Repo
  alias ShoppingList.Recipes.Ingredient
  alias ShoppingList.Recipes.Item

  def create_list(dishes) do
    query = from item in Item,
      join: ingr in Ingredient,
      on: item.ingredient_id == ingr.id,
      where: item.dish in ^dishes,
      group_by: [ingr.name, ingr.metric],
      order_by: [ingr.name],
      select: %Item{
        quantity: sum(item.quantity),
        ingredient: %Ingredient{
          name: ingr.name,
          metric: ingr.metric,
        },
      }

    %{
      items: Repo.all(query)
    }
  end
end
