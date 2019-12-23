defmodule ShoppingList.DishesTest do
  use ShoppingList.DataCase

  import ShoppingList.Factory

  alias ShoppingList.Dishes
  alias ShoppingList.Recipes.{Item, Ingredient}

  describe "dishes" do
    alias ShoppingList.Dishes.Dish

    @valid_attrs %{name: "some name", items: [%{
      quantity: 42, ingredient_id: nil
      }]
    }
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_dishes/0 returns all dishes without items" do
      dish = insert!(:dish) |> items_not_loaded()
      assert Dishes.list_dishes() == [dish]
    end

    test "get_dish!/1 returns the dish with items and ingredients" do
      persisted = insert!(:dish)
      recalled = Dishes.get_dish!(persisted.id)
      item = recalled.items |> List.first

      assert recalled == persisted
      assert %Item{} = item
      assert %Ingredient{} = item.ingredient
    end

    test "create_dish/1 with valid data creates a dish" do
      %{ id: ingredient_id } = insert!(:ingredient)
      attrs = %{ @valid_attrs | items: [ %{ quantity: 42, ingredient_id: ingredient_id } ] }

      assert {:ok, %Dish{} = dish} = Dishes.create_dish(attrs)
      assert dish.name == "some name"
      assert %Item{} = dish.items |> List.first
    end

    test "create_dish/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dishes.create_dish(@invalid_attrs)
    end

    test "update_dish/2 with updated name updates the dish" do
      dish = insert!(:dish)
      assert {:ok, %Dish{} = dish} = Dishes.update_dish(dish, @update_attrs)
      assert dish.name == "some updated name"
    end

    test "update_dish/2 with changes in items updates the dish" do
      dish = insert!(:dish)
      old_item = dish.items |> List.first |> Map.from_struct
      %{ id: ingredient_id } = insert!(:ingredient, %{ metric: "grams", name: "sugar" })
      new_items = %{ "1" => %{ quantity: 5, ingredient_id: ingredient_id }, "2" => old_item }
      attrs = %{ items: new_items }

      assert {:ok, %Dish{} = dish} = Dishes.update_dish(dish, attrs)
      assert dish.items |> Enum.count == 2
      [ last | [first] ] = dish.items
      assert last.quantity == 5
      assert first.quantity == 42
    end

    test "update_dish/2 with invalid data returns error changeset" do
      dish = insert!(:dish)
      assert {:error, %Ecto.Changeset{}} = Dishes.update_dish(dish, @invalid_attrs)
      assert dish == Dishes.get_dish!(dish.id)
    end

    test "delete_dish/1 deletes the dish" do
      dish = insert!(:dish)
      assert {:ok, %Dish{}} = Dishes.delete_dish(dish)
      assert_raise Ecto.NoResultsError, fn -> Dishes.get_dish!(dish.id) end
    end

    test "change_dish/1 returns a dish changeset" do
      dish = insert!(:dish)
      assert %Ecto.Changeset{} = Dishes.change_dish(dish)
    end

    test "create_list_from/1 returns a shopping list" do
      dish_ids = insert_hotdog_and_perkelt()
      result = Dishes.create_list_from(dish_ids)
      expected = %{
        items: [
          %{
            ingredient: %{
              name: "salt",
              metric: "pinches",
            },
            optional: false,
            quantity: 11,
          },
          %{
            ingredient: %{
              name: "sausage",
              metric: "pieces",
            },
            optional: false,
            quantity: 2,
          },
        ]
      }
      assert ^expected = result
    end

    defp items_not_loaded(dish = %Dish{}) do
      dish
      |> struct(items: %Ecto.Association.NotLoaded{
        __field__: :items,
        __cardinality__: :many,
        __owner__: ShoppingList.Dishes.Dish
      })
    end
  end
end
