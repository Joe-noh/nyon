defmodule NyonWeb.SessionController do
  use NyonWeb, :controller

  alias Nyon.Identities
  alias Nyon.Twitter.{OauthToken, Profile}

  action_fallback NyonWeb.FallbackController

  def create(conn, %{"verifier" => verifier, "token" => token}) do
    twitter_module = Application.get_env(:nyon, :twitter_module, Nyon.Twitter)

    with {:ok, oauth = %OauthToken{}} <- twitter_module.fetch_access_token(verifier, token) do
      case Identities.get_twitter_account(oauth.user_id) do
        nil ->
          {:ok, profile = %Profile{}} = twitter_module.fetch_profile(oauth.token, oauth.token_secret)

          {:ok, user} =
            Identities.create_user(%{
              "name" => profile.screen_name,
              "display_name" => profile.name,
              "twitter_id" => profile.user_id
            })

          render_user(conn, user)

        account ->
          render_user(conn, account.user)
      end
    else
      {:error, 401} -> {:error, :unquthorized}
    end
  end

  def render_user(conn, user) do
    {:ok, token, _} = NyonWeb.Token.generate_and_sign(%{"user_id" => user.id})

    conn
    |> put_status(:created)
    |> render("show.json", user: user, token: token)
  end
end
