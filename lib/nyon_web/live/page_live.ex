defmodule NyonWeb.PageLive do
  use NyonWeb, :live_view

  alias Nyon.Identities

  @impl true
  def mount(_params, %{"current_user_id" => user_id}, socket) do
    {:ok, current_user} = Identities.find_user(user_id)
    send(self(), :get_player)

    socket =
      socket
      |> assign(:user, current_user)
      |> assign(:device, nil)
      |> assign(:device_state, :loading)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: Routes.signin_path(socket, :index))}
  end

  @impl true
  def handle_info(:get_player, socket = %{assigns: %{user: user}}) do
    {:ok, account} = Identities.refresh_if_expired(user.spotify_account)

    case Sptfy.Player.get_devices(account.access_token) do
      {:ok, devices = [device | _]} ->
        skyline_pigeon = "spotify:track:5MimWt53Ukh0gcv7mC0Rnx"
        device = find_active_device(devices) || device

        Sptfy.Player.play(account.access_token, uris: [skyline_pigeon], device_id: device.id)

        socket = assign(socket, :device, device)
        {:noreply, socket}

      {:ok, []} ->
        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  defp find_active_device(devices) do
    Enum.find(devices, fn d -> d.is_active end)
  end
end
