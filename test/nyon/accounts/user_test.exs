defmodule Nyon.Accounts.UserTest do
  use Nyon.DataCase

  alias Nyon.Accounts.User

  describe "changeset" do
    @attrs %{name: "john_doe", email: "hello@example.com"}

    test "downcases email" do
      changeset = User.changeset(%User{}, Map.put(@attrs, :email, "HELLO@EXAMPLE.COM"))

      assert Map.get(changeset.changes, :email) == "hello@example.com"
    end

    test "name have to match the condition" do
      Enum.each ~w[john_doe john], fn name ->
        assert User.changeset(%User{}, Map.put(@attrs, :name, name)).valid?, name
      end

      Enum.each ~w[ab ___ john-doe], fn name ->
        refute User.changeset(%User{}, Map.put(@attrs, :name, name)).valid?, name
      end
    end
  end
end
