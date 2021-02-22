defmodule Nyon.Minesweeper.Board do
  alias Nyon.Minesweeper.Cell

  defstruct width: 0,
            height: 0,
            gameover: false,
            cells: %{}

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

  defp count_neighbors(board = %__MODULE__{cells: cells}) do
    cells =
      Enum.reduce(coords(board), cells, fn {x, y}, acc ->
        Map.update!(acc, {x, y}, fn cell ->
          %Cell{cell | neighbor: do_count_neighbors(cells, {x, y})}
        end)
      end)

    %__MODULE__{board | cells: cells}
  end

  defp do_count_neighbors(cells, {x, y}) do
    {x, y}
    |> neighbor_coords()
    |> Enum.count(fn neighbor ->
      case Map.get(cells, neighbor) do
        nil -> false
        cell -> cell.mine
      end
    end)
  end

  def open_cell(board = %__MODULE__{cells: cells}, {x, y}) do
    case do_open_cell(cells, {x, y}) do
      {:ok, cells} ->
        %__MODULE__{board | cells: cells}

      :boom ->
        gameover(board)
    end
  end

  defp do_open_cell(cells, {x, y}) do
    case Map.get(cells, {x, y}) do
      nil ->
        {:ok, cells}

      %Cell{state: :open} ->
        {:ok, cells}

      %Cell{state: :closed, mine: true} ->
        :boom

      %Cell{state: :closed, mine: false, neighbor: 0} ->
        cells =
          cells
          |> Map.update!({x, y}, &Cell.open/1)
          |> safe_open_neighbors({x, y})

        {:ok, cells}

      %Cell{state: :closed, mine: false, neighbor: n} when n > 0 ->
        cells = cells |> Map.update!({x, y}, &Cell.open/1)

        {:ok, cells}

      %Cell{state: :flag} ->
        {:ok, cells}
    end
  end

  defp safe_open_neighbors(cells, {x, y}) do
    {x, y}
    |> neighbor_coords()
    |> Enum.reduce(cells, fn neighbor, cells ->
      {:ok, cells} = do_open_cell(cells, neighbor)
      cells
    end)
  end

  defp gameover(board = %__MODULE__{gameover: false, cells: cells}) do
    cells =
      Enum.reduce(coords(board), cells, fn {x, y}, acc ->
        Map.update!(acc, {x, y}, &Cell.open/1)
      end)

    %__MODULE__{board | gameover: true, cells: cells}
  end

  defp gameover(board) do
    board
  end

  def flag_cell(board = %__MODULE__{cells: cells}, {x, y}) do
    cells = Map.update!(cells, {x, y}, &Cell.toggle_flag/1)

    %__MODULE__{board | cells: cells}
  end

  def open_neighbors(board = %__MODULE__{cells: cells}, {x, y}) do
    case Map.get(cells, {x, y}) do
      nil ->
        board

      %Cell{state: state} when state in [:flag, :closed] ->
        board

      %Cell{state: :open, mine: false, neighbor: n} ->
        neighbor_coords = neighbor_coords({x, y})

        flag_count = Enum.count(neighbor_coords, fn coord ->
          case Map.get(cells, coord) do
            nil -> false
            cell -> cell.state == :flag
          end
        end)

        if flag_count == n do
          Enum.all?(neighbor_coords, fn coord ->
            case Map.get(cells, coord) do
              nil -> true
              cell -> (cell.state == :flag && cell.mine == true) || (cell.state != :flag && cell.mine == false)
            end
          end)
          |> case do
            true ->
              cells = Enum.reduce(neighbor_coords, cells, fn coord, cells ->
                case Map.get(cells, coord) do
                  nil ->
                    cells

                  %Cell{state: state} when state in [:flag, :open] ->
                    cells

                  %Cell{state: :closed} ->
                    Map.update!(cells, coord, &Cell.open/1)
                end
              end)

              %__MODULE__{board | cells: cells}

            false ->
              gameover(board)
          end
        else
          board
        end
    end
  end

  defp coords(%__MODULE__{width: width, height: height}) do
    for w <- 1..width, h <- 1..height, do: {w - 1, h - 1}
  end

  defp neighbor_coords({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end
end
