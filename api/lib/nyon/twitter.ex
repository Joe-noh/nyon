defmodule Nyon.Twitter do
  defmodule Profile do
    @moduledoc false

    defstruct name: "",
              screen_name: "",
              user_id: ""

    def new(attrs) do
      %__MODULE__{
        name: Map.get(attrs, :display_name),
        screen_name: Map.get(attrs, :name),
        user_id: Map.get(attrs, :id_str)
      }
    end
  end

  defmodule OauthToken do
    @moduledoc false

    defstruct token: "",
              token_secret: "",
              screen_name: "",
              user_id: ""

    def new(attrs) do
      %__MODULE__{
        token: Map.get(attrs, :oauth_token),
        token_secret: Map.get(attrs, :oauth_token_secret),
        screen_name: Map.get(attrs, :name),
        user_id: Map.get(attrs, :user_id)
      }
    end
  end

  def fetch_profile(access_token, access_token_secret) do
    configure_extwitter(access_token: access_token, access_token_secret: access_token_secret)

    profile = ExTwitter.verify_credentials() |> Nyon.Twitter.Profile.new()
    {:ok, profile}
  end

  def fetch_access_token(oauth_verifier, oauth_token) do
    configure_extwitter()

    with {:ok, token} <- ExTwitter.access_token(oauth_verifier, oauth_token) do
      {:ok, Nyon.Twitter.OauthToken.new(token)}
    end
  end

  def fetch_authorize_url do
    configure_extwitter()
    callback_url = Application.get_env(:nyon, :twitter) |> Keyword.get(:callback_url)

    with %{oauth_token: token} <- ExTwitter.request_token(callback_url) do
      ExTwitter.authorize_url(token)
    end
  end

  defp configure_extwitter(opts \\ []) do
    config =
      Application.get_env(:nyon, :twitter)
      |> Keyword.take([:consumer_key, :consumer_secret])
      |> Kernel.++(opts)

    ExTwitter.configure(:process, config)
  end
end
