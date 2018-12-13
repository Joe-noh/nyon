defmodule NyonWeb.IdentityResolver do
  def find_user(_parent, %{id: id}, _resolution) do
    user = %{id: id, name: "Example"}

    {:ok, user}
  end

  def create_user(_parent, %{name: name}, _resolution) do
    user = %{id: "abc", name: name}

    {:ok, user}
  end
end
