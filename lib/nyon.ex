defmodule Nyon do
  @moduledoc """
  Nyon keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def spotify_config do
    Application.get_env(:nyon, :spotify) |> Enum.into(%{})
  end
end
