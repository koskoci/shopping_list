defmodule ShoppingList.Recipes.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :dish, :string
    field :optional, :boolean, default: false
    field :quantity, :integer
    belongs_to :ingredient, ShoppingList.Recipes.Ingredient

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:quantity, :optional, :dish, :ingredient_id])
    |> validate_required([:quantity, :optional, :dish, :ingredient_id])
    |> foreign_key_constraint(:ingredient, name: :items_ingredient_id_fkey)
  end
end
