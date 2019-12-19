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

  def create_dish(attrs \\ %{}) do
    flour = insert!(:ingredient)
    salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
    insert!(:item, Map.merge(%{ingredient_id: flour.id}, attrs))
    insert!(:item, Map.merge(%{ingredient_id: salt.id}, attrs))
  end
end
