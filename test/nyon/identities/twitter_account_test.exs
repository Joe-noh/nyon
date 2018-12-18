defmodule Nyon.Identities.TwitterAccountTest do
  use Nyon.DataCase, async: true

  alias Nyon.Repo
  alias Nyon.Identities.{User, TwitterAccount}

  @attrs %{twitter_id: "123456789"}

  setup do
    user_attrs = %{
      name: "john_doe",
      display_name: "John Doe",
      avatar_url: "https://example.com/img.png"
    }

    user = %User{} |> User.changeset(user_attrs) |> Repo.insert!()

    %{user: user}
  end

  describe "presence validation" do
    setup %{user: user} do
      account = user |> build_assoc(:twitter_account, @attrs)

      %{account: account}
    end

    test "twitter_id is required", %{account: account} do
      changeset = account |> TwitterAccount.changeset(%{twitter_id: " "})

      assert %{twitter_id: _} = errors_on(changeset)
    end
  end

  describe "uniqueness constraint" do
    setup %{user: user} do
      account = user |> build_assoc(:twitter_account, @attrs) |> Repo.insert!()

      %{account: account}
    end

    test "twitter_id should be unique", %{account: account} do
      {:error, changeset} =
        %TwitterAccount{}
        |> TwitterAccount.changeset(%{@attrs | twitter_id: account.twitter_id})
        |> Repo.insert()

      assert %{twitter_id: _} = errors_on(changeset)
    end
  end
end
