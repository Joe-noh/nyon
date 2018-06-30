defmodule NyonWeb.ConnCaseHelpers do
  import Plug.Conn

  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  def login(conn, user) do
    conn
    |> Plug.Session.call(@session)
    |> fetch_session()
    |> put_session(:user_id, user.id)
  end
end
