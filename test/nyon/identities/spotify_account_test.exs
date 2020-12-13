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

  describe "token_expired?/1" do
    test "returns true if access token is expired" do
      account = account_expires_after(-60)

      assert SpotifyAccount.token_expired?(account) == true
    end

    test "returns false if access token is not expired" do
      account = account_expires_after(60)

      assert SpotifyAccount.token_expired?(account) == false
    end

    test "allows 30 seconds clock skew" do
      assert account_expires_after(0) |> SpotifyAccount.token_expired?() == true
      assert account_expires_after(28) |> SpotifyAccount.token_expired?() == true
      assert account_expires_after(32) |> SpotifyAccount.token_expired?() == false
    end
  end

  defp account_expires_after(seconds) do
    expires_at = DateTime.utc_now() |> DateTime.add(seconds, :second)
    {:ok, %{spotify_account: account}} = Fixtures.spotify_account(%{token_expires_at: expires_at}) |> Identities.signup_user()

    account
  end
end
