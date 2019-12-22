defmodule ShoppingList.RecipesTest do
  use ShoppingList.DataCase

  import ShoppingList.Factory

  alias ShoppingList.Recipes
  alias ShoppingList.Recipes.Ingredient

  describe "ingredients" do
    @valid_attrs %{name: "flour", metric: "grams"}
    @invalid_attrs %{name: "flour", metric: 5}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = insert!(:ingredient)
      assert Recipes.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = insert!(:ingredient)
      assert Recipes.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{name: "flour", metric: "grams"}} = Recipes.create_ingredient(@valid_attrs)
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_ingredient(@invalid_attrs)
    end

    test "delete_ingredient/1 deletes the ingredient if no items belong to it" do
      ingredient = insert!(:ingredient)
      assert {:ok, %Ingredient{}} = Recipes.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredient!(ingredient.id) end
    end

    test "delete_ingredient/1 with item returns error changeset" do
      ingredient = insert!(:ingredient)
      insert!(:item, ingredient_id: ingredient.id)
      assert {:error, %Ecto.Changeset{}} = Recipes.delete_ingredient(ingredient)
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = insert!(:ingredient)
      assert %Ecto.Changeset{} = Recipes.change_ingredient(ingredient)
    end
  end
end
