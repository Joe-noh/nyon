defmodule Nyon.Factory do
  def params_for(:user) do
    %{
      name: Faker.Internet.user_name() |> String.replace(".", "_"),
      email: [Nanoid.generate(), Faker.Internet.domain_name()] |> Enum.join("@"),
    }
  end
end
