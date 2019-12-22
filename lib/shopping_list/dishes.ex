defmodule ShoppingList.Dishes do
  import Ecto.Query, warn: false
  alias ShoppingList.Repo

  alias ShoppingList.Dishes.Dish

  def list_dishes do
    Repo.all(Dish)
  end

  def get_dish!(id) do
    Repo.one! from d in Dish,
      where: ^id == d.id,
      preload: [items: :ingredient]
  end

  def create_dish(attrs \\ %{}) do
    %Dish{}
    |> Dish.changeset(attrs)
    |> Repo.insert()
  end

  def update_dish(%Dish{} = dish, attrs) do
    dish
    |> Dish.changeset(attrs)
    |> Repo.update()
  end

  def delete_dish(%Dish{} = dish) do
    Repo.delete(dish)
  end

  def change_dish(%Dish{} = dish) do
    Dish.changeset(dish, %{})
  end

  def create_list_from(dish_ids) do
    query = from dish in Dish,
      join: item in assoc(dish, :items),
      join: ingr in assoc(item, :ingredient),
      where: dish.id in ^dish_ids,
      group_by: [item.optional, ingr.name, ingr.metric],
      select: %{
        quantity: sum(item.quantity),
        ingredient: %{
          name: ingr.name,
          metric: ingr.metric,
        },
        optional: item.optional,
      }

      %{
        items: Repo.all(query)
      }
  end
end
