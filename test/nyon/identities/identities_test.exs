defmodule Nyon.IdentitiesTest do
  use Nyon.DataCase

  alias Nyon.Identities
  alias Nyon.Identities.{User, TwitterAccount}

  @params %{"name" => "john_doe", "display_name" => "John Doe", "twitter_id" => "123456789"}

  describe "create_user/1" do
    test "insert user and twitter account" do
      {:ok, %{user: user, twitter_account: twitter_account}} = Identities.create_user(@params)

      assert user.name == @params["name"]
      assert user.display_name == @params["display_name"]
      assert twitter_account.twitter_id == @params["twitter_id"]
      assert user.id == twitter_account.user_id
    end
  end

  describe "update_user/2" do
    setup do
      Identities.create_user(@params)
    end

    test "update only display_name", %{user: user} do
      {:ok, user} = Identities.update_user(user, %{"name" => "john", "display_name" => "John"})

      assert user.name != "john"
      assert user.display_name == "John"
    end
  end

  describe "delete_user/1" do
    setup do
      Identities.create_user(@params)
    end

    test "delete user and twitter account", %{user: user, twitter_account: twitter_account} do
      assert {:ok, _user} = Identities.delete_user(user)

      assert Repo.get(User, user.id) == nil
      assert Repo.get(TwitterAccount, twitter_account.id) == nil
    end
  end
end
