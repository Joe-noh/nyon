defmodule NyonWeb.Components.JukeboxPlayer do
  use Phoenix.LiveComponent

  alias Nyon.Jukebox.QueueServer

  @impl true
  def mount(socket) do
    if user = Map.get(socket.assigns, :current_user) do
      :ok = QueueServer.bulk_enqueue(user.spotify_account)
    end

    queue = QueueServer.queue()

    {:ok, assign(socket, :queue, queue)}
  end
end
