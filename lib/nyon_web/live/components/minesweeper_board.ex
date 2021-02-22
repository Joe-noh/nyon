defmodule NyonWeb.Components.MinesweeperBoard do
  use Phoenix.LiveComponent

  alias Nyon.Minesweeper.Server

  @impl true
  def mount(socket) do
    board = Server.board()

    {:ok, assign(socket, :board, board)}
  end

  @impl true
  def update(_, socket) do
    board = Server.board()

    {:ok, assign(socket, :board, board)}
  end

  @impl true
  def handle_event("open-cell", %{"x" => x, "y" => y}, socket) do
    coord = {String.to_integer(x), String.to_integer(y)}
    board = Server.open_cell(coord)
    Phoenix.PubSub.broadcast(Nyon.PubSub, "board:1", :update_board)

    {:noreply, assign(socket, :board, board)}
  end

  @impl true
  def handle_event("restart", _, socket) do
    :ok = Server.reset()
    Phoenix.PubSub.broadcast(Nyon.PubSub, "board:1", :update_board)

    {:noreply, assign(socket, :board, Server.board())}
  end
end
