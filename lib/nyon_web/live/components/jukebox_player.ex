defmodule NyonWeb.Components.JukeboxPlayer do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    Process.send_after(self(), :enqueue, 200)

    {:ok, socket}
  end

  @impl true
  def update(%{queue: [track | _]}, socket) do
    image = Enum.min_by(track.album.images, fn image -> image.width end)
    artist = Enum.map(track.artists, fn artist -> artist.name end) |> Enum.join(", ")

    track = %{
      title: track.name,
      artist: artist,
      image: image.url
    }

    {:ok, assign(socket, :track, track)}
  end

  def update(%{queue: []}, socket) do
    {:ok, assign(socket, :track, nil)}
  end
end
