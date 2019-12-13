defmodule ShoppingList.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias ShoppingList.Repo

  alias ShoppingList.Recipes.Ingredient
  alias ShoppingList.Recipes.Item

  def list_dishes do
    from(i in Item, distinct: true, select: i.dish)
    |> Repo.all
  end

  def create_list(dishes) do
    from(
      i in Item,
      where: i.dish in ^dishes,
      group_by: i.ingredient_id,
      select: { i.ingredient_id, sum(i.quantity) }
    )
    |> Repo.all
    |> Enum.map(&expand(&1))
  end

  defp expand({ingredient_id, quantity}) do
    %{
      quantity: quantity,
      ingredient: Repo.get!(Ingredient, ingredient_id),
    }
  end

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, ...}

  """
  def create_ingredient(attrs \\ %{}) do
    Ingredient.changeset(%Ingredient{}, attrs)
    |> Repo.insert
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, ...}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    Ingredient.changeset(ingredient, attrs)
    |> Repo.update
  end

  @doc """
  Deletes a Ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, ...}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    ingredient
    |> Ecto.Changeset.change
    |> Ecto.Changeset.no_assoc_constraint(:items)
    |> Repo.delete
  end

  @doc """
  Returns a data structure for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Todo{...}

  """
  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end

  alias ShoppingList.Recipes.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    query = from i in Item, preload: [:ingredient]
    Repo.all(query)
  end

  @doc """
  Gets a single item.

  Raises if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

  """
  def get_item!(id) do
    Repo.one!(from i in Item, where: ^id == i.id)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes an Item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{source: %Item{}}

  """
  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end
end
