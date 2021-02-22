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

  def close(cell = %__MODULE__{state: :flag}) do
    %__MODULE__{cell | state: :closed}
  end

  def close(cell) do
    cell
  end

  def toggle_flag(cell = %__MODULE__{state: :closed}) do
    %__MODULE__{cell | state: :flag}
  end

  def toggle_flag(cell = %__MODULE__{state: :flag}) do
    %__MODULE__{cell | state: :closed}
  end

  def toggle_flag(cell) do
    cell
  end
end
