defmodule Nyon.Accounts.MagicLinkTest do
  use Nyon.DataCase

  alias Nyon.Accounts.MagicLink

  describe "changeset" do
    @attrs %{email: "hello@example.com"}

    test "generates token" do
      changeset = MagicLink.changeset(%MagicLink{}, @attrs)

      assert Map.get(changeset.changes, :token) |> is_binary
    end

    test "generates expired_at" do
      changeset = MagicLink.changeset(%MagicLink{}, @attrs)

      assert Map.get(changeset.changes, :expired_at)
    end
  end
end
