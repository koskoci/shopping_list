defmodule ShoppingListWeb.ItemController do
  use ShoppingListWeb, :controller

  alias ShoppingList.{Recipes, Dishes}
  alias ShoppingList.Recipes.Item

  def index(conn, _params) do
    items = Recipes.list_items()
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Recipes.change_item(%Item{})

    render_new(conn, changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Recipes.create_item(item_params) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.item_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_new(conn, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Recipes.get_item!(id)
    {:ok, _item} = Recipes.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end

  defp render_new(conn, changeset) do
    ingredients = Recipes.list_ingredients()
    dishes = Dishes.list_dishes() |> Enum.join(", ")

    render(conn, "new.html", changeset: changeset, ingredients: ingredients, dishes: dishes)
  end
end
