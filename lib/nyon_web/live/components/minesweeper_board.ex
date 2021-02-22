defmodule NyonWeb.Components.MinesweeperBoard do
  use Phoenix.LiveComponent

  alias Nyon.Minesweeper.Board

  @impl true
  def mount(socket) do
    socket = socket |> assign(:board, Board.new(10, 10, 20))

    {:ok, socket}
  end

  @impl true
  def handle_event("open-cell", %{"x" => x, "y" => y}, socket = %{assigns: %{board: board}}) do
    coord = {String.to_integer(x), String.to_integer(y)}
    socket = socket |> assign(:board, Board.open_cell(board, coord))

    {:noreply, socket}
  end

  @impl true
  def handle_event("restart", _, socket) do
    socket = socket |> assign(:board, Board.new(10, 10, 20))

    {:noreply, socket}
  end
end
