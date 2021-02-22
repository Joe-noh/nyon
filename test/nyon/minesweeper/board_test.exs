defmodule Nyon.Minesweeper.BoardTest do
  use ExUnit.Case, async: true

  alias Nyon.Minesweeper.Board

  describe "new" do
    test "returns an initialized board" do
      board = Board.new(10, 20, 30)

      assert board.width == 10
      assert board.height == 20
      assert Enum.count(board.cells, fn {_coord, cell} -> cell.mine end) == 30
      assert Enum.all?(board.cells, fn {_coord, cell} -> cell.state == :closed end)
    end
  end
end
