defmodule Nyon.Jukebox.QueueServerTest do
  use Nyon.DataCase, async: false

  import Mock

  alias Nyon.Jukebox.QueueServer
  alias Nyon.Identities

  describe "queue/0" do
    setup [:clear_queue]

    test "queue is empty at first" do
      assert QueueServer.queue() == []
    end
  end

  describe "enqueue_recommends/1" do
    setup [:clear_queue, :setup_user]

    test "fetch recoommendations and enqueue them", %{spotify_account: spotify_account} do
      tracks = [%Sptfy.Object.FullTrack{}]

      with_mock Nyon.Jukebox.Spotify, [], [get_recommends: fn _ -> {:ok, tracks} end] do
        assert :ok == QueueServer.enqueue_recommends(spotify_account)
        assert QueueServer.queue() == tracks
      end
    end

    test "enqueue nothing when already enqueued", %{spotify_account: spotify_account} do
      tracks = [%Sptfy.Object.FullTrack{}]

      with_mock Nyon.Jukebox.Spotify, [], [get_recommends: fn _ -> {:ok, tracks} end] do
        assert :ok == QueueServer.enqueue_recommends(spotify_account)
        assert QueueServer.queue() == tracks

        assert :ok == QueueServer.enqueue_recommends(spotify_account)
        assert QueueServer.queue() == tracks
      end
    end

    test "enqueue nothing on error", %{spotify_account: spotify_account} do
      with_mock Nyon.Jukebox.Spotify, [], [get_recommends: fn _ -> {:error, nil} end] do
        assert :ok == QueueServer.enqueue_recommends(spotify_account)
        assert QueueServer.queue() == []
      end
    end
  end

  defp clear_queue(_context) do
    QueueServer.clear_queue()
  end

  defp setup_user(_context) do
    Nyon.Fixtures.spotify_account() |> Identities.signup_user()
  end
end
