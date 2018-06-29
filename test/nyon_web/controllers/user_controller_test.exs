defmodule NyonWeb.UserControllerTest do
  use NyonWeb.ConnCase

  alias Nyon.Accounts

  @attrs %{email: "hello@example.com", name: "john_doe"}

  describe "new action" do
    setup [:create_magic_link]

    test "renders form", %{conn: conn, magic_link: magic_link} do
      html = conn
        |> get(Routes.user_path(conn, :new), %{token: magic_link.token})
        |> html_response(200)

      assert html =~ "New User"
    end
  end

  describe "show action" do
    setup [:create_user]

    test "renders the user", %{conn: conn, user: user} do
      html = conn
        |> get(Routes.user_path(conn, :show, user.id))
        |> html_response(200)

      assert html =~ "Show User"
    end
  end

  describe "create action" do
    setup [:create_magic_link]

    test "redirects to show", %{conn: conn, magic_link: magic_link} do
      params = Map.put(@attrs, :token, magic_link.token)
      conn = post(conn, Routes.user_path(conn, :create), user: params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn, magic_link: magic_link} do
      params = Map.put(%{}, :token, magic_link.token)
      html = conn
        |> post(Routes.user_path(conn, :create), user: params)
        |> html_response(200)

      assert html =~ "New User"
    end
  end

  describe "edit action" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, Routes.user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update action" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{@attrs | name: "jack"})
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      html = conn
        |> get(Routes.user_path(conn, :show, user))
        |> html_response(200)

      assert html =~ "jack"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      html = conn
        |> put(Routes.user_path(conn, :update, user), user: %{name: "___"})
        |> html_response(200)

      assert html =~ "Edit User"
    end
  end

  describe "delete action" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, Routes.user_path(conn, :delete, user)
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end

  defp create_magic_link(_) do
    magic_link = fixture(:magic_link)
    %{magic_link: magic_link}
  end

  defp fixture(:user) do
    Accounts.create_user(@attrs) |> elem(1)
  end

  defp fixture(:magic_link) do
    Accounts.create_magic_link(%{email: @attrs.email}) |> elem(1)
  end
end
