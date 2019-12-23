defmodule ShoppingListWeb.DishController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Dishes
  alias ShoppingList.Dishes.Dish
  alias ShoppingList.Recipes
  alias ShoppingList.Recipes.Item

  def index(conn, _params) do
    dishes = Dishes.list_dishes()
    render(conn, "index.html", dishes: dishes)
  end

  def new(conn, _params) do
    changeset = Dishes.change_dish(%Dish{ items: [ %Item{} ] })
    render_new(conn, changeset)
  end

  def create(conn, %{"dish" => dish_params}) do
    case Dishes.create_dish(dish_params) do
      {:ok, dish} ->
        conn
        |> put_flash(:info, "Dish created successfully.")
        |> redirect(to: Routes.dish_path(conn, :show, dish))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_new(conn, changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dish = Dishes.get_dish!(id)

    render(conn, "show.html", dish: dish)
  end

  def edit(conn, %{"id" => id}) do
    dish = Dishes.get_dish!(id)
    changeset = Dishes.change_dish(dish)

    render_edit(conn, changeset, dish)
  end

  def update(conn, %{"id" => id, "dish" => dish_params}) do
    dish = Dishes.get_dish!(id)

    case Dishes.update_dish(dish, dish_params) do
      {:ok, dish} ->
        conn
        |> put_flash(:info, "Dish updated successfully.")
        |> redirect(to: Routes.dish_path(conn, :show, dish))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_edit(conn, changeset, dish)
    end
  end

  def delete(conn, %{"id" => id}) do
    dish = Dishes.get_dish!(id)
    {:ok, _dish} = Dishes.delete_dish(dish)

    conn
    |> put_flash(:info, "Dish deleted successfully.")
    |> redirect(to: Routes.dish_path(conn, :index))
  end

  defp render_new(conn, changeset) do
    ingredients = Recipes.list_ingredients()

    render(conn, "new.html", changeset: changeset, ingredients: ingredients)
  end

  defp render_edit(conn, changeset, dish) do
    ingredients = Recipes.list_ingredients()

    render(conn, "edit.html", dish: dish, changeset: changeset, ingredients: ingredients)
  end
end
