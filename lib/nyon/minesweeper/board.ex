defmodule Nyon.Minesweeper.Board do
  alias Nyon.Minesweeper.Cell

  defstruct [
    width: 0,
    height: 0,
    cells: %{}
  ]

  def new(width, height, mine_count) do
    build_board(width, height, mine_count) |> count_neighbors()
  end

  defp build_board(width, height, mine_count) do
    board = %__MODULE__{width: width, height: height}
    cells =
      1..(width * height)
      |> Enum.reduce([], fn index, acc -> [index <= mine_count | acc] end)
      |> Enum.shuffle()
      |> Enum.zip(coords(board))
      |> Enum.reduce(%{}, fn {mine, {x, y}}, acc ->
        Map.put(acc, {x, y}, %Cell{mine: mine, state: :closed})
      end)

    %__MODULE__{board | cells: cells}
  end

  defp coords(%__MODULE__{width: width, height: height}) do
    for w <- 1..width, h <- 1..height, do: {w-1, h-1}
  end

  defp count_neighbors(board = %__MODULE__{cells: cells}) do
    cells = Enum.reduce(coords(board), cells, fn {x, y}, acc ->
      Map.update!(acc, {x, y}, fn cell ->
        %Cell{cell | neighbor: do_count_neighbors(cells, {x, y})}
      end)
    end)

    %__MODULE__{board | cells: cells}
  end

  defp do_count_neighbors(cells, {x, y}) do
    [
      {x-1, y-1},
      {x, y-1},
      {x+1, y-1},
      {x-1, y},
      {x+1, y},
      {x-1, y+1},
      {x, y+1},
      {x+1, y+1},
    ]
    |> Enum.count(fn coord ->
      case Map.get(cells, coord) do
        nil -> false
        cell -> cell.mine
      end
    end)
  end
end
