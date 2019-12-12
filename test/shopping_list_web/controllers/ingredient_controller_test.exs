defmodule ShoppingListWeb.IngredientControllerTest do
  use ShoppingListWeb.ConnCase

  alias ShoppingList.Recipes

  @create_attrs %{name: "flour", metric: "grams"}
  @invalid_attrs %{name: "flour", metric: 5}

  def fixture(:ingredient) do
    {:ok, ingredient} = Recipes.create_ingredient(@create_attrs)
    ingredient
  end

  def fixture(:ingredient_with_item) do
    ingredient = fixture(:ingredient)
    %{dish: "some dish", quantity: 42, ingredient_id: ingredient.id}
    |> Recipes.create_item()
    ingredient
  end

  describe "index" do
    test "lists all ingredients", %{conn: conn} do
      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ingredients"
    end
  end

  describe "new ingredient" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.ingredient_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ingredient"
    end
  end

  describe "create ingredient" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ingredient_path(conn, :create), ingredient: @create_attrs)

      assert redirected_to(conn) == Routes.ingredient_path(conn, :index)

      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Ingredients"
    end

    @tag :wip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ingredient_path(conn, :create), ingredient: @invalid_attrs)
      assert html_response(conn, 200) =~ "Cannot create ingredient, already created"
    end
  end

  describe "delete ingredient" do
    setup [:create_ingredient]

    test "deletes chosen ingredient", %{conn: conn, ingredient: ingredient} do
      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200) =~ @create_attrs.metric

      conn = delete(conn, Routes.ingredient_path(conn, :delete, ingredient))
      assert redirected_to(conn) == Routes.ingredient_path(conn, :index)

      conn = get(conn, Routes.ingredient_path(conn, :index))
      refute html_response(conn, 200) =~ @create_attrs.metric
    end
  end

  describe "delete ingredient with item" do
    setup [:create_ingredient_with_item]

    test "redirects to index and renders errors when ingredient belongs to an item", %{conn: conn, ingredient: ingredient} do
      conn = delete(conn, Routes.ingredient_path(conn, :delete, ingredient))
      redir_path = Routes.ingredient_path(conn, :index)

      assert redir_path == redirected_to(conn)
      conn = get(recycle(conn), redir_path)
      assert html_response(conn, 200) =~ "Cannot delete ingredient, still in use"
    end
  end

  defp create_ingredient(_) do
    ingredient = fixture(:ingredient)
    {:ok, ingredient: ingredient}
  end

  defp create_ingredient_with_item(_) do
    ingredient = fixture(:ingredient_with_item)

    {:ok, ingredient: ingredient}
  end
end
