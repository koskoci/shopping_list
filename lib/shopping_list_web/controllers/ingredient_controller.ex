defmodule ShoppingListWeb.IngredientController do
  use ShoppingListWeb, :controller

  alias ShoppingList.Recipes
  alias ShoppingList.Recipes.Ingredient

  def index(conn, _params) do
    ingredients = Recipes.list_ingredients()
    render(conn, "index.html", ingredients: ingredients)
  end

  def new(conn, _params) do
    changeset = Recipes.change_ingredient(%Ingredient{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ingredient" => ingredient_params}) do
    case Recipes.create_ingredient(ingredient_params) do
      {:ok, ingredient} ->
        conn
        |> put_flash(:info, "Ingredient created successfully.")
        |> redirect(to: Routes.ingredient_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Cannot create ingredient, already created")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ingredient = Recipes.get_ingredient!(id)
    case Recipes.delete_ingredient(ingredient) do
      {:ok, ingredient} ->
        conn
        |> put_flash(:info, "Ingredient deleted successfully.")
        |> redirect(to: Routes.ingredient_path(conn, :index))

      {:error, %Ecto.Changeset{} = %{ errors: errors }} ->
        conn
        |> put_flash(:error, "Cannot delete ingredient, still in use")
        |> redirect(to: Routes.ingredient_path(conn, :index))
    end
  end
end
