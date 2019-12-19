defmodule ShoppingListWeb.DishControllerTest do
  use ShoppingListWeb.ConnCase

  import ShoppingList.Factory

  describe "show" do
    test "shows the dish", %{conn: conn} do
      create_dish()

      conn = get(conn, Routes.dish_path(conn, :show, "some dish"))
      assert html_response(conn, 200) =~ "some dish"
    end
  end
end
