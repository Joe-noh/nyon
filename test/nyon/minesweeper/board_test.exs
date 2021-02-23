defmodule Nyon.Minesweeper.BoardTest do
  use ExUnit.Case, async: true

  alias Nyon.Minesweeper.{Board, Cell}

  describe "new/3" do
    test "returns an initialized board" do
      board = Board.new(10, 20, 30)

      assert board.width == 10
      assert board.height == 20
      assert Enum.count(board.cells, fn {_coord, cell} -> cell.mine end) == 30
      assert Enum.all?(board.cells, fn {_coord, cell} -> cell.state == :closed end)
    end
  end

  describe "open_cell/2" do
    setup [:build_board]

    test "opens a safe cell" do
    end

    test "gameover if open a mine cell" do
    end

    test "has no effect on finished game" do
    end
  end

  describe "flag_cell/2" do
    setup [:build_board]

    test "cannot put up flag on open cell" do
    end

    test "removes flag if already flagged" do
    end

    test "has no effect on finished game" do
    end
  end

  describe "open_neighbors/2" do
    setup [:build_board]

    test "opens neighbor safe cells if correctly flagged" do
    end

    test "has no effect if flags is not enough" do
    end

    test "has no effect if num of flags is more than num of neighbor mines" do
    end

    test "gameover if incorrectly flagged" do
    end

    test "has no effect on finished game" do
    end
  end

  defp build_board(_) do
    # F 1 _
    # 1 2 _
    # _ _ X

    board = %Board{
      height: 3,
      width: 3,
      gameover: false,
      cells: %{
        {0, 0} => %Cell{neighbor: 0, mine: true, state: :flag},
        {1, 0} => %Cell{neighbor: 1, mine: false, state: :open},
        {2, 0} => %Cell{neighbor: 0, mine: false, state: :closed},
        {0, 1} => %Cell{neighbor: 1, mine: false, state: :open},
        {1, 1} => %Cell{neighbor: 2, mine: false, state: :open},
        {2, 1} => %Cell{neighbor: 1, mine: false, state: :closed},
        {0, 2} => %Cell{neighbor: 0, mine: false, state: :closed},
        {1, 2} => %Cell{neighbor: 1, mine: false, state: :closed},
        {2, 2} => %Cell{neighbor: 0, mine: true, state: :closed}
      }
    }

    {:ok, board: board}
  end
end
