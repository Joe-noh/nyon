defmodule Nyon.Factory do
  def params_for(:user), do: %{
    name: name(),
    email: email(),
  }

  def params_for(:magic_link), do: %{
    email: email(),
  }

  def params_for(:post), do: %{
    body: Faker.Lorem.paragraph(),
  }

  defp name do
    Faker.Internet.user_name() |> String.replace(~r/[\.\']/, "_")
  end

  defp email do
    [Nanoid.generate(), Faker.Internet.domain_name()] |> Enum.join("@")
  end
end
