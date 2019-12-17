defmodule ShoppingListWeb.DishController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Dishes

  def show(conn, %{"name" => name}) do
    dish = Dishes.get_dish(name)

    render(conn, "show.html", dish: dish)
  end
end
