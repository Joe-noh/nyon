defmodule Nyon.Jukebox.Spotify do
  alias Nyon.Identities
  alias Nyon.Identities.SpotifyAccount
  alias Sptfy.Object.{Paging, Recommendation}

  def get_recommends(spotify_account) do
    with {:ok, %SpotifyAccount{access_token: access_token}} <- Identities.refresh_if_expired(spotify_account) do
      get_recommends_from_top_tracks(access_token)
    end
  end

  defp get_recommends_from_top_tracks(access_token) do
    with {:ok, %Paging{items: items}} <- Sptfy.Personalization.get_top_tracks(access_token),
         seed = items |> Enum.shuffle() |> Enum.take(5) |> ids(),
         {:ok, %Recommendation{tracks: tracks}} <- Sptfy.Browse.get_recommendations(access_token, seed_tracks: seed) do
      Sptfy.Track.get_tracks(access_token, ids: ids(tracks))
    end
  end

  defp ids(list) do
    list |> Enum.map(fn entry -> entry.id end)
  end
end
