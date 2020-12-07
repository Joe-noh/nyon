defmodule Nyon.Fixtures do
  def spotify_account(attrs \\ %{}) do
    Map.merge(%{
      spotify_user_id: random_string(),
      access_token: random_string(),
      refresh_token: random_string(),
      token_expires_at: DateTime.utc_now() |> DateTime.add(3600, :second)
    }, attrs)
  end

  defp random_string() do
    :crypto.strong_rand_bytes(32) |> Base.encode64() |> binary_part(0, 32)
  end
end
