defmodule ShoppingList.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias ShoppingList.Repo

  alias ShoppingList.Recipes.Ingredient

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
  def get_ingredient!(id) do
    Repo.one!(from i in Ingredient, where: ^id == i.id)
  end

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
    Repo.delete(ingredient)
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
end
