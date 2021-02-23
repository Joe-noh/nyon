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

    test "opens a safe cell", %{board: board} do
      board = %Board{cells: %{{2, 0} => cell}} = Board.open_cell(board, {2, 0})

      assert cell.state == :open
      refute board.gameover
    end

    test "gameover if open a mine cell", %{board: board} do
      assert %Board{gameover: true} = Board.open_cell(board, {2, 2})
    end

    test "has no effect on finished game", %{board: board} do
      board = %Board{board | gameover: true}
      board = %Board{cells: %{{2, 0} => cell}} = Board.open_cell(board, {2, 0})

      assert cell.state == :closed
      assert board.gameover
    end
  end

  describe "flag_cell/2" do
    setup [:build_board]

    test "cannot put up flag on open cell", %{board: board} do
      %Board{cells: %{{1, 0} => cell}} = Board.flag_cell(board, {1, 0})

      assert cell.state == :open
    end

    test "removes flag if already flagged", %{board: board} do
      %Board{cells: %{{0, 0} => cell}} = Board.flag_cell(board, {0, 0})

      assert cell.state == :closed
    end

    test "has no effect on finished game", %{board: board} do
      board = %Board{board | gameover: true}
      board = %Board{cells: %{{2, 2} => cell}} = Board.flag_cell(board, {2, 2})

      assert cell.state == :closed
      assert board.gameover
    end
  end

  describe "open_neighbors/2" do
    setup [:build_board]

    test "opens neighbor safe cells if correctly flagged", %{board: board} do
      board = %Board{cells: cells} = Board.open_neighbors(board, {1, 0})

      assert %Cell{state: :open} = Map.get(cells, {2, 0})
      assert %Cell{state: :open} = Map.get(cells, {2, 1})
      refute board.gameover
    end

    test "opens continuous 0-mine cells", %{board: board} do
      board = %Board{cells: cells} = Board.open_neighbors(board, {1, 0})

      assert %Cell{state: :open} = Map.get(cells, {2, 0})
      assert %Cell{state: :open} = Map.get(cells, {3, 0})
      assert %Cell{state: :open} = Map.get(cells, {2, 1})
      assert %Cell{state: :open} = Map.get(cells, {3, 1})
      refute board.gameover
    end

    test "has no effect if flags is not enough", %{board: board} do
      %Board{cells: cells} = Board.open_neighbors(board, {1, 1})

      assert %Cell{state: :closed} = Map.get(cells, {2, 0})
    end

    test "has no effect if num of flags is more than num of neighbor mines", %{board: board} do
      board = Board.flag_cell(board, {2, 0})
      %Board{cells: cells} = Board.open_neighbors(board, {1, 0})

      assert %Cell{state: :flag} = Map.get(cells, {2, 0})
      assert %Cell{state: :closed} = Map.get(cells, {2, 1})
    end

    test "gameover if incorrectly flagged", %{board: board} do
      board = Board.flag_cell(board, {2, 0})
      board = Board.open_neighbors(board, {1, 1})

      assert board.gameover
    end

    test "has no effect on finished game", %{board: board} do
      board = %Board{board | gameover: true}
      board = %Board{cells: cells} = Board.open_neighbors(board, {1, 0})

      assert %Cell{state: :closed} = Map.get(cells, {2, 0})
      assert %Cell{state: :closed} = Map.get(cells, {2, 1})
      assert board.gameover
    end
  end

  defp build_board(_) do
    # F 1 _ _
    # 1 2 _ _
    # _ _ X _

    board = %Board{
      height: 3,
      width: 3,
      gameover: false,
      cells: %{
        {0, 0} => %Cell{neighbor: 0, mine: true, state: :flag},
        {1, 0} => %Cell{neighbor: 1, mine: false, state: :open},
        {2, 0} => %Cell{neighbor: 0, mine: false, state: :closed},
        {3, 0} => %Cell{neighbor: 0, mine: false, state: :closed},
        {0, 1} => %Cell{neighbor: 1, mine: false, state: :open},
        {1, 1} => %Cell{neighbor: 2, mine: false, state: :open},
        {2, 1} => %Cell{neighbor: 1, mine: false, state: :closed},
        {3, 1} => %Cell{neighbor: 1, mine: false, state: :closed},
        {0, 2} => %Cell{neighbor: 0, mine: false, state: :closed},
        {1, 2} => %Cell{neighbor: 1, mine: false, state: :closed},
        {2, 2} => %Cell{neighbor: 0, mine: true, state: :closed},
        {3, 2} => %Cell{neighbor: 1, mine: false, state: :closed}
      }
    }

    {:ok, board: board}
  end
end
