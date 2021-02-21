defmodule Nyon.Minesweeper.Cell do
  defstruct [
    mine: false,
    neighbor: 0,
    state: :close # :close | :flag | :open
  ]
end
