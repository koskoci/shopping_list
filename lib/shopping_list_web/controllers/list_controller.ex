defmodule ShoppingListWeb.ListController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Dishes

  def new(conn, _params) do
    dishes = Dishes.list_dishes()

    render(conn, "new.html", dishes: dishes)
  end

  def create(conn, %{"list" => %{"dishes" => dish_ids}}) do
    list = Dishes.create_list_from(dish_ids)

    render(conn, "show.html", list: list)
  end
end
