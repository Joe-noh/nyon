defmodule NyonWeb.PageLive do
  use NyonWeb, :live_view

  alias Nyon.Jukebox.QueueServer

  @impl true
  def mount(_params, session, socket) do
    :ok = Phoenix.PubSub.subscribe(Nyon.PubSub, "board:1")
    socket =
      socket
      |> assign_current_user(session)
      |> assign(:queue, [])

    {:ok, socket}
  end

  @impl true
  def handle_info(:update_board, socket) do
    send_update(NyonWeb.Components.MinesweeperBoard, id: 1)

    {:noreply, socket}
  end

  def handle_info(:enqueue, socket) do
    if user = Map.get(socket.assigns, :current_user) do
      :ok = QueueServer.enqueue_recommends(user.spotify_account)
    end

    queue = QueueServer.queue()

    {:noreply, assign(socket, :queue, queue)}
  end

  defp assign_current_user(socket, %{"current_user_id" => user_id}) do
    case Nyon.Identities.find_user(user_id) do
      {:ok, user} -> assign(socket, :current_user, user)
      _error -> assign(socket, :current_user, nil)
    end
  end

  defp assign_current_user(socket, _session) do
    assign(socket, :current_user, nil)
  end
end
