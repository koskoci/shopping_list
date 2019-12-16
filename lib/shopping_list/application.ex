defmodule ShoppingList.Application do
  use Application

  def start(_type, _args) do
    children = [
      ShoppingList.Repo,
      ShoppingListWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ShoppingList.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ShoppingListWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
