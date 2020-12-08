defmodule Nyon.Identities.SpotifyAccountTest do
  use Nyon.DataCase, async: true

  alias Nyon.Identities
  alias Nyon.Identities.SpotifyAccount

  describe "validation" do
    test "spotify_user_id must be unique" do
      {:ok, %{spotify_account: account1}} = Fixtures.spotify_account() |> Identities.signup_user()
      {:ok, %{spotify_account: account2}} = Fixtures.spotify_account() |> Identities.signup_user()

      {:error, changeset} =
        account1
        |> SpotifyAccount.changeset(%{spotify_user_id: account2.spotify_user_id})
        |> Repo.update()

      assert errors_on(changeset).spotify_user_id
    end
  end
end
