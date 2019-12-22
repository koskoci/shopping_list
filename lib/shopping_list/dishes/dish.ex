defmodule ShoppingList.Dishes.Dish do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dishes" do
    field :name, :string
    has_many :items, ShoppingList.Recipes.Item, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(dish, attrs) do
    dish
    |> cast(attrs, [:name])
    |> cast_assoc(:items, required: true)
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
