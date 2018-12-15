ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Nyon.Repo, :manual)

defmodule Nyon.TwitterMock do
  def fetch_profile!(_, _) do
    %{id_str: "123456789", screen_name: "john_doe", name: "John Doe"}
  end
end
