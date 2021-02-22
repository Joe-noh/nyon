defmodule Nyon.Minesweeper.Cell do
  defstruct [
    # :closed | :flag | :open
    state: :closed,
    mine: false,
    neighbor: 0
  ]

  def open(cell = %__MODULE__{state: :closed}) do
    %__MODULE__{cell | state: :open}
  end

  def open(cell) do
    cell
  end
end
