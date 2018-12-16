defmodule Nyon.Identities.UserTest do
  use Nyon.DataCase, async: true

  alias Nyon.Repo
  alias Nyon.Identities.User

  @attrs %{name: "john_doe", display_name: "John Doe"}

  describe "presence validation" do
    test "name is required" do
      changeset = %User{} |> User.changeset(%{@attrs | name: " "})

      assert %{name: _errors} = errors_on(changeset)
    end

    test "display_name is required" do
      changeset = %User{} |> User.changeset(%{@attrs | display_name: " "})

      assert %{display_name: _errors} = errors_on(changeset)
    end
  end

  describe "length validation" do
    @len50 String.duplicate("a", 50)
    @len51 String.duplicate("a", 51)

    test "name length =< 50" do
      changeset = %User{} |> User.changeset(%{@attrs | name: @len50})
      assert %{} == errors_on(changeset)

      changeset = %User{} |> User.changeset(%{@attrs | name: @len51})
      assert %{name: _} = errors_on(changeset)
    end

    test "display_name length =< 50" do
      changeset = %User{} |> User.changeset(%{@attrs | display_name: @len50})
      assert %{} == errors_on(changeset)

      changeset = %User{} |> User.changeset(%{@attrs | display_name: @len51})
      assert %{display_name: _} = errors_on(changeset)
    end
  end

  describe "format validation" do
    test "name should match \w" do
      changeset = %User{} |> User.changeset(%{@attrs | name: "john doe"})
      assert %{name: _} = errors_on(changeset)

      changeset = %User{} |> User.changeset(%{@attrs | name: "/john"})
      assert %{name: _} = errors_on(changeset)
    end
  end

  describe "uniqueness constraint" do
    setup do
      user = %User{} |> User.changeset(@attrs) |> Repo.insert!()

      %{user: user}
    end

    test "name should be unique", %{user: user} do
      {:error, changeset} =
        %User{} |> User.changeset(%{@attrs | name: user.name}) |> Repo.insert()

      assert %{name: _} = errors_on(changeset)
    end
  end
end
