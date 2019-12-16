defmodule ShoppingList.RecipesTest do
  use ShoppingList.DataCase

  alias ShoppingList.Recipes
  alias ShoppingList.Recipes.Ingredient

  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{name: "flour", metric: "grams"})
      |> Recipes.create_ingredient()

    ingredient
  end

  def item_with_ingredient(ingredient_id) do
    {:ok, item} =
      %{dish: "some dish", optional: true, quantity: 42, ingredient_id: ingredient_id}
      |> Recipes.create_item()

    item
  end

  def create_flour() do
    {:ok, %Ingredient{id: id}} = Recipes.create_ingredient(%{name: "flour", metric: "grams"})
    id
  end

  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{dish: "some dish", optional: true, quantity: 42, ingredient_id: nil})
      |> Recipes.create_item()

    item
  end

  describe "dishes" do
    test "list_dishes/0 lists all distinct dishes" do
      flour = ingredient_fixture()
      salt = ingredient_fixture(%{name: "salt", metric: "pinches"})
      item_with_ingredient(flour.id)
      item_with_ingredient(salt.id)
      item_fixture(%{dish: "some other dish", ingredient_id: flour.id})

      assert ["some other dish", "some dish"] = Recipes.list_dishes()
    end
  end

  describe "ingredients" do
    @valid_attrs %{name: "flour", metric: "grams"}
    @invalid_attrs %{name: "flour", metric: 5}

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

    test "delete_ingredient/1 deletes the ingredient if no items belong to it" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Recipes.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredient!(ingredient.id) end
    end

    test "delete_ingredient/1 with item returns error changeset" do
      ingredient = ingredient_fixture()
      item_with_ingredient(ingredient.id)
      assert {:error, %Ecto.Changeset{}} = Recipes.delete_ingredient(ingredient)
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Recipes.change_ingredient(ingredient)
    end
  end

  describe "items" do
    alias ShoppingList.Recipes.Item

    @valid_attrs %{dish: "some dish", optional: true, quantity: 42, ingredient_id: nil}
    @invalid_attrs %{dish: nil, optional: nil, quantity: nil, ingredient: nil}

    test "list_items/0 returns all items with ingredients" do
      ingredient = ingredient_fixture()
      item = item_with_ingredient(ingredient.id)
      [recalled_item] = Recipes.list_items()

      assert %{item | ingredient: nil} == %{recalled_item | ingredient: nil}
      assert %Ingredient{} = recalled_item.ingredient
    end

    test "get_item!/1 returns the item with given id without its ingredient" do
      item = item_fixture(ingredient_id: create_flour())
      assert Recipes.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      id = create_flour()
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
      id = create_flour()

      assert {:error, %Ecto.Changeset{}} = Recipes.create_item(%{@valid_attrs | ingredient_id: id + 1})
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture(ingredient_id: create_flour())
      assert {:ok, %Item{}} = Recipes.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_item!(item.id) end
    end

    test "change_item/1 returns an item changeset" do
      item = item_fixture(ingredient_id: create_flour())
      assert %Ecto.Changeset{} = Recipes.change_item(item)
    end
  end
end
