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

  describe "items" do
    alias ShoppingList.Recipes.Item

    @valid_attrs %{dish: "some dish", optional: true, quantity: 42, ingredient_id: nil}
    @invalid_attrs %{dish: nil, optional: nil, quantity: nil, ingredient: nil}

    test "list_items/0 returns all items with ingredients" do
      item = insert!(:item_with_ingredient)
      [recalled_item] = Recipes.list_items()

      assert %{item | ingredient: nil} == %{recalled_item | ingredient: nil}
      assert %Ingredient{} = recalled_item.ingredient
    end

    test "get_item!/1 returns the item with given id without its ingredient" do
      item = insert!(:item, ingredient_id: insert!(:ingredient).id )
      assert Recipes.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      id = insert!(:ingredient).id
      assert {:ok, %Item{} = item} = Recipes.create_item(%{@valid_attrs | ingredient_id: id})
      assert item.dish == "some dish"
      assert item.optional == true
      assert item.quantity == 42
      assert item.ingredient_id == id
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_item(@invalid_attrs)
    end

    test "create_item/1 without ingredient_id returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_item(@valid_attrs)
    end

    test "create_item/1 with invalid ingredient_id returns error changeset" do
      id = insert!(:ingredient).id

      assert {:error, %Ecto.Changeset{}} = Recipes.create_item(%{@valid_attrs | ingredient_id: id + 1})
    end

    test "delete_item/1 deletes the item" do
      item = insert!(:item, ingredient_id: insert!(:ingredient).id )
      assert {:ok, %Item{}} = Recipes.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_item!(item.id) end
    end

    test "change_item/1 returns an item changeset" do
      item = insert!(:item, ingredient_id: insert!(:ingredient).id )
      assert %Ecto.Changeset{} = Recipes.change_item(item)
    end
  end
end
