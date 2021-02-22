defmodule Nyon.Minesweeper.Server do
  use GenServer

  alias Nyon.Minesweeper.Board

  @name {:global, Nyon.Minesweeper.Server}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def board do
    GenServer.call(@name, :board)
  end

  def open_cell(coord) do
    GenServer.call(@name, {:open_cell, coord})
  end

  def flag_cell(coord) do
    GenServer.call(@name, {:flag_cell, coord})
  end

  def reset do
    GenServer.call(@name, :reset)
  end

  # callbacks

  def init(_) do
    {:ok, new_game()}
  end

  def handle_call(:board, _from, board) do
    {:reply, board, board}
  end

  def handle_call({:open_cell, coord}, _from, board) do
    board = Board.open_cell(board, coord)

    {:reply, board, board}
  end

  def handle_call({:flag_cell, coord}, _from, board) do
    board = Board.flag_cell(board, coord)

    {:reply, board, board}
  end

  def handle_call(:reset, _from, _board) do
    {:reply, :ok, new_game()}
  end

  defp new_game do
    Board.new(15, 15, 30)
  end
end
