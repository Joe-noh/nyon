defmodule NyonWeb.Token do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(iss: "Nyon", aud: "User", default_exp: 90 * 24 * 3600)
  end
end
