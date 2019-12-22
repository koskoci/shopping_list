defmodule ShoppingList.Factory do
  alias ShoppingList.Repo
  alias ShoppingList.Recipes.{Ingredient, Item}
  alias ShoppingList.Dishes.Dish

  def build(:ingredient) do
    %Ingredient{ name: "flour", metric: "grams" }
  end

  def build(:item) do
    %Item{ quantity: 42, ingredient_id: nil }
  end

  def build(:item_with_ingredient) do
    persisted = insert!(:ingredient)
    struct(build(:item), %{ ingredient_id: persisted.id })
  end

  def build(:dish) do
    %Dish{
      name: "some name",
      items: [
        %Item{
          quantity: 42, ingredient: %Ingredient{ name: "flour", metric: "grams" }
        }
      ],
    }
  end

  def build(factory_name, attrs) do
    factory_name |> build() |> struct(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    Repo.insert!(build(factory_name, attrs))
  end

  def insert_hotdog_and_perkelt() do
    sausage = insert!(:ingredient, %{name: "sausage", metric: "pieces"})
    salt = insert!(:ingredient, %{name: "salt", metric: "pinches"})
    item_1 = build(:item, %{ingredient_id: salt.id, quantity: 1})
    item_2 = build(:item, %{ingredient_id: sausage.id, quantity: 1})
    item_3 = build(:item, %{ingredient_id: salt.id, quantity: 10})
    hotdog = Repo.insert!(%Dish{name: "hotdog", items: [item_1, item_2]})
    perkelt = Repo.insert!(%Dish{name: "perkelt", items: [item_2, item_3]})

    [hotdog.id, perkelt.id]
  end
end
