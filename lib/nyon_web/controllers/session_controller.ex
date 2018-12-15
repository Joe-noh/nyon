defmodule NyonWeb.SessionController do
  use NyonWeb, :controller

  alias Nyon.Identities

  action_fallback NyonWeb.FallbackController

  def create(conn, %{"token" => token, "secret" => secret}) do
    twitter_module = Application.get_env(:nyon, :twitter_module, Nyon.Twitter)

    %{id_str: twitter_id, screen_name: name, name: display_name} =
      twitter_module.fetch_profile!(token, secret)

    case Identities.get_twitter_account(twitter_id) do
      nil ->
        with attrs = %{"name" => name, "display_name" => display_name, "twitter_id" => twitter_id},
             {:ok, user} <- Identities.create_user(attrs) do
          do_create(conn, user)
        end

      account ->
        do_create(conn, account.user)
    end
  end

  def do_create(conn, user) do
    {:ok, token, _} = NyonWeb.Token.generate_and_sign(%{"user_id" => user.id})

    conn
    |> put_status(:created)
    |> render("show.json", user: user, token: token)
  end
end
