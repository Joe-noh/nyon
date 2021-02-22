defmodule NyonWeb.PageLive do
  use NyonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(Nyon.PubSub, "board:1")

    {:ok, socket}
  end

  @impl true
  def handle_info(:update_board, socket) do
    send_update(NyonWeb.Components.MinesweeperBoard, id: 1)

    {:noreply, socket}
  end
end
