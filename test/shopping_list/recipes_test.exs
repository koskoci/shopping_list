defmodule ShoppingList.RecipesTest do
  use ShoppingList.DataCase

  alias ShoppingList.Recipes

  describe "ingredients" do
    alias ShoppingList.Recipes.Ingredient

    @valid_attrs %{name: "flour", metric: "grams"}
    @update_attrs %{name: "flour", metric: "g"}
    @invalid_attrs %{name: "flour", metric: 5}

    def ingredient_fixture(attrs \\ %{}) do
      {:ok, ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_ingredient()

      ingredient
    end

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Recipes.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Recipes.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{name: "flour", metric: "grams"}} = Recipes.create_ingredient(@valid_attrs)
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{} = ingredient} = Recipes.update_ingredient(ingredient, @update_attrs)
      assert ingredient.metric == "g"
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Recipes.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Recipes.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Recipes.change_ingredient(ingredient)
    end
  end

  describe "items" do
    alias ShoppingList.Recipes.Item

    @valid_attrs %{dish: "some dish", optional: true, quantity: 42}
    @update_attrs %{dish: "some updated dish", optional: false, quantity: 43}
    @invalid_attrs %{dish: nil, optional: nil, quantity: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Recipes.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Recipes.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Recipes.create_item(@valid_attrs)
      assert item.dish == "some dish"
      assert item.optional == true
      assert item.quantity == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_item(@invalid_attrs)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Recipes.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Recipes.change_item(item)
    end
  end
end
