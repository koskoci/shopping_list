defmodule ShoppingList.Factory do
  alias ShoppingList.Repo
  alias ShoppingList.Recipes.{Ingredient, Item}

  def build(:ingredient) do
    %Ingredient{ name: "flour", metric: "grams" }
  end

  def build(:item) do
    %Item{ dish: "some dish", quantity: 42, ingredient_id: nil }
  end

  def build(:item_with_ingredient) do
    persisted = insert!(:ingredient)
    struct(build(:item), %{ ingredient_id: persisted.id })
  end

  def build(factory_name, attrs) do
    factory_name |> build() |> struct(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    Repo.insert!(build(factory_name, attrs))
  end
end
