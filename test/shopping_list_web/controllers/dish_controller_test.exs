defmodule ShoppingListWeb.DishControllerTest do
  use ShoppingListWeb.ConnCase

  import ShoppingList.Factory

  @create_attrs %{name: "some name", items: [%{
    quantity: 42, ingredient_id: nil
    }]
  }
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all dishes", %{conn: conn} do
      conn = get(conn, Routes.dish_path(conn, :index))
      assert html_response(conn, 200) =~ "My Dishes"
    end
  end

  describe "new dish" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.dish_path(conn, :new))
      assert html_response(conn, 200) =~ "New Dish"
    end
  end

  describe "create dish" do
    test "redirects to show when data is valid", %{conn: conn} do
      %{id: ingredient_id} = insert!(:ingredient, %{ name: "flour", metric: "grams" })
      attrs = %{ @create_attrs | items: [%{quantity: 42, ingredient_id: ingredient_id}] }

      conn = post(conn, Routes.dish_path(conn, :create), dish: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.dish_path(conn, :show, id)

      conn = get(conn, Routes.dish_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some name"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dish_path(conn, :create), dish: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Dish"
    end
  end

  describe "edit dish" do
    setup [:create_dish]

    test "renders form for editing chosen dish", %{conn: conn, dish: dish} do
      conn = get(conn, Routes.dish_path(conn, :edit, dish))
      assert html_response(conn, 200) =~ "Edit Dish"
    end
  end

  describe "update dish" do
    setup [:create_dish]

    test "redirects when data is valid", %{conn: conn, dish: dish} do
      conn = put(conn, Routes.dish_path(conn, :update, dish), dish: @update_attrs)
      assert redirected_to(conn) == Routes.dish_path(conn, :show, dish)

      conn = get(conn, Routes.dish_path(conn, :show, dish))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, dish: dish} do
      conn = put(conn, Routes.dish_path(conn, :update, dish), dish: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Dish"
    end
  end

  describe "delete dish" do
    setup [:create_dish]

    test "deletes chosen dish", %{conn: conn, dish: dish} do
      conn = delete(conn, Routes.dish_path(conn, :delete, dish))
      assert redirected_to(conn) == Routes.dish_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.dish_path(conn, :show, dish))
      end
    end
  end

  defp create_dish(_) do
    dish = insert!(:dish)
    {:ok, dish: dish}
  end
end
