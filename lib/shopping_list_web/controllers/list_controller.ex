defmodule ShoppingListWeb.ListController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Recipes
  alias ShoppingList.Tallies

  def new(conn, _params) do
    dishes = Recipes.list_dishes()

    render(conn, "new.html", dishes: dishes)
  end

  def create(conn, %{"list" => %{"dishes" => dishes}}) do
    list = Tallies.create_list(dishes)

    render(conn, "show.html", list: list)
  end
end
