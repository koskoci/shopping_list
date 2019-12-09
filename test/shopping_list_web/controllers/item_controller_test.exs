defmodule ShoppingListWeb.ItemControllerTest do
  use ShoppingListWeb.ConnCase

  alias ShoppingList.Recipes

  @create_attrs %{dish: "some dish", optional: true, quantity: 42}
  @update_attrs %{dish: "some updated dish", optional: false, quantity: 43}
  @invalid_attrs %{dish: nil, optional: nil, quantity: nil}

  def fixture(:item) do
    {:ok, item} = Recipes.create_item(@create_attrs)
    item
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Items"
    end
  end

  describe "new item" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :new))
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "create item" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @create_attrs)
      assert redirected_to(conn) == Routes.item_path(conn, :index)

      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Items"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.item_path(conn, :create), item: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item"
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = get(conn, Routes.item_path(conn, :index))
      assert html_response(conn, 200) =~ @create_attrs.dish

      conn = delete(conn, Routes.item_path(conn, :delete, item))
      assert redirected_to(conn) == Routes.item_path(conn, :index)

      conn = get(conn, Routes.item_path(conn, :index))
      refute html_response(conn, 200) =~ @create_attrs.dish
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
