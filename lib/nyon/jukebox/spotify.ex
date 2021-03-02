defmodule Nyon.Jukebox.Spotify do
  alias Nyon.Identities
  alias Nyon.Identities.SpotifyAccount

  def get_recommends(spotify_account) do
    with {:ok, %SpotifyAccount{access_token: access_token}} <- Identities.refresh_if_expired(spotify_account),
         {:ok, %Sptfy.Object.Paging{items: items}} <- Sptfy.Personalization.get_top_tracks(access_token) do
      {:ok, items}
    end
  end
end
