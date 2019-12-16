defmodule ShoppingList.Recipes.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :metric, :string
    field :name, :string
    has_many :items, ShoppingList.Recipes.Item

    timestamps()
  end

  @allowed_fields [:name, :metric]

  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> unique_constraint(:name)
  end
end
