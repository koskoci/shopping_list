defmodule ShoppingList.Recipes do

  import Ecto.Query, warn: false

  alias ShoppingList.Repo
  alias ShoppingList.Recipes.Ingredient
  alias ShoppingList.Recipes.Item

  def list_dishes do
    from(i in Item, distinct: true, select: i.dish)
    |> Repo.all
  end

  def list_ingredients do
    Repo.all(Ingredient)
  end

  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  def create_ingredient(attrs \\ %{}) do
    Ingredient.changeset(%Ingredient{}, attrs)
    |> Repo.insert
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    Ingredient.changeset(ingredient, attrs)
    |> Repo.update
  end

  def delete_ingredient(%Ingredient{} = ingredient) do
    ingredient
    |> Ecto.Changeset.change
    |> Ecto.Changeset.no_assoc_constraint(:items)
    |> Repo.delete
  end

  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end

  def list_items do
    query = from i in Item, preload: [:ingredient]
    Repo.all(query)
  end

  def get_item!(id) do
    Repo.one!(from i in Item, where: ^id == i.id)
  end

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end
end
