defmodule Nyon.Identities.UserTest do
  use Nyon.DataCase, async: true

  import Ecto.Query

  alias Nyon.Identities
  alias Nyon.Identities.SpotifyAccount

  describe "association" do
    setup [:setup_user]

    test "spotify_account will be deleted on deleting the user", %{user: user} do
      spotify_account = user |> Ecto.assoc(:spotify_account) |> Repo.one!()
      user |> Repo.delete!()

      refute SpotifyAccount |> where(id: ^spotify_account.id) |> Repo.exists?()
    end
  end

  defp setup_user(_context) do
    Nyon.Fixtures.spotify_account() |> Identities.signup_user()
  end
end
