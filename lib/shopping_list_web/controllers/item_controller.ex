defmodule ShoppingListWeb.ItemController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Recipes
  alias ShoppingList.Recipes.Item

  def index(conn, _params) do
    items = Recipes.list_items()
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Recipes.change_item(%Item{})
    ingredients = Recipes.list_ingredients()

    render(conn, "new.html", changeset: changeset, ingredients: ingredients)
  end

  def create(conn, %{"item" => item_params}) do
    case Recipes.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: Routes.item_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        ingredients = Recipes.list_ingredients()

        render(conn, "new.html", changeset: changeset, ingredients: ingredients)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Recipes.get_item!(id)
    {:ok, _item} = Recipes.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: Routes.item_path(conn, :index))
  end
end
