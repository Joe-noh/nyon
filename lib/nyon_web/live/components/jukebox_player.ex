defmodule NyonWeb.Components.JukeboxPlayer do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    Process.send_after(self(), :enqueue, 200)

    {:ok, socket}
  end

  @impl true
  def update(%{queue: queue}, socket) do
    tracks = Enum.map(queue, fn track ->
      image = Enum.min_by(track.album.images, fn image -> image.width end)

      %{image: image.url}
    end)

    {:ok, assign(socket, :tracks, tracks)}
  end
end
