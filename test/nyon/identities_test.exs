defmodule Nyon.IdentitiesTest do
  use Nyon.DataCase, async: true

  alias Nyon.Identities
  alias Nyon.Identities.User

  describe "signup_user" do
    test "create a user" do
      assert {:ok, %{user: _, spotify_account: _}} = Identities.signup_user(Fixtures.spotify_account())
    end
  end

  describe "find_user" do
    test "returns user" do
      {:ok, %{user: user}} = Identities.signup_user(Fixtures.spotify_account())

      assert {:ok, %User{}} = Identities.find_user(user.id)
    end

    test "returns error tuple when not found" do
      assert {:error, :not_found} = Identities.find_user("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")
    end
  end

  describe "find_user_by_spotify_id" do
    test "returns a user" do
      {:ok, %{user: %User{id: id}}} = Identities.signup_user(Fixtures.spotify_account(%{spotify_user_id: "abc"}))

      assert {:ok, %User{id: ^id}} = Identities.find_user_by_spotify_id("abc")
    end

    test "returns error tuple when not found" do
      assert {:error, :not_found} = Identities.find_user_by_spotify_id("not-exists")
    end
  end
end
