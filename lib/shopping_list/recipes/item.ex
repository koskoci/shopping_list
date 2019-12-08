defmodule ShoppingList.Recipes.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :dish, :string
    field :optional, :boolean, default: false
    field :quantity, :integer
    field :ingredient_id, :id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:quantity, :optional, :dish])
    |> validate_required([:quantity, :optional, :dish])
  end
end
