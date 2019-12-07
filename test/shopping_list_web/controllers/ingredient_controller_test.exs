defmodule ShoppingListWeb.IngredientControllerTest do
  use ShoppingListWeb.ConnCase

  alias ShoppingList.Recipes

  @create_attrs %{name: "flour", metric: "grams"}
  @update_attrs %{name: "flour", metric: "g"}
  @invalid_attrs %{name: "flour", metric: 5}

  def fixture(:ingredient) do
    {:ok, ingredient} = Recipes.create_ingredient(@create_attrs)
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

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ingredient_path(conn, :create), ingredient: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ingredient"
    end
  end

  describe "edit ingredient" do
    setup [:create_ingredient]

    test "renders form for editing chosen ingredient", %{conn: conn, ingredient: ingredient} do
      conn = get(conn, Routes.ingredient_path(conn, :edit, ingredient))
      assert html_response(conn, 200) =~ "Edit Ingredient"
    end
  end

  describe "update ingredient" do
    setup [:create_ingredient]

    test "redirects when data is valid", %{conn: conn, ingredient: ingredient} do
      conn = put(conn, Routes.ingredient_path(conn, :update, ingredient), ingredient: @update_attrs)
      assert redirected_to(conn) == Routes.ingredient_path(conn, :index)

      conn = get(conn, Routes.ingredient_path(conn, :index))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, ingredient: ingredient} do
      conn = put(conn, Routes.ingredient_path(conn, :update, ingredient), ingredient: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ingredient"
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

  defp create_ingredient(_) do
    ingredient = fixture(:ingredient)
    {:ok, ingredient: ingredient}
  end
end
