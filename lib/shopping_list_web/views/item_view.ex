defmodule ShoppingListWeb.ItemView do
  use ShoppingListWeb, :view

  def list(ingredients) do
    ingredients
    |> Enum.map(&({"#{&1.metric} of #{&1.name}", &1.id}))
  end

  def sort(items) do
    items
    |> Enum.sort(&(&1.dish <= &2.dish))
  end
end
