defmodule ShoppingList.IngredientTest do
  use ShoppingList.DataCase

  alias ShoppingList.Recipes.Ingredient
  alias ShoppingList.Repo

  describe "when flour is already added" do
    setup [:add_flour]

    test "cannot add flour again" do
      changeset = Ingredient.changeset(%Ingredient{}, %{name: "flour", metric: "lightyears"})
      assert { :error, changeset } = Repo.insert(changeset)
      assert changeset.valid? == false
      assert [ name: {"has already been taken", _} ] = changeset.errors
    end

    test "cannot add Flour either" do
      changeset = Ingredient.changeset(%Ingredient{}, %{name: "Flour", metric: "lightyears"})
      assert { :error, changeset } = Repo.insert(changeset)
      assert changeset.valid? == false
      assert [ name: {"has already been taken", _} ] = changeset.errors
    end
  end

  defp add_flour(_context) do
    Repo.insert(%Ingredient{name: "flour", metric: "grams"})
    :ok
  end
end
