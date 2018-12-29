defmodule NyonWeb.AuthorizeUrlControllerTest do
  use NyonWeb.ConnCase, async: false

  alias ExUnitAssertMatch, as: Match

  @pattern Match.map(%{"url" => Match.binary()})

  defmodule TwitterMock do
    def fetch_authorize_url do
      {:ok, "https://api.twitter.com/oauth/authorize?aaa=bbb"}
    end
  end

  setup_all do
    Application.put_env(:nyon, :twitter_module, TwitterMock)
    :ok
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /authorize_url" do
    test "renders authorize url", %{conn: conn} do
      json =
        conn
        |> get(Routes.authorize_url_path(conn, :show))
        |> json_response(200)
        |> Map.get("data")

      Match.assert(@pattern, json)
    end
  end
end
