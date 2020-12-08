defmodule NyonWeb.PageLive do
  use NyonWeb, :live_view

  alias Nyon.Identities

  @impl true
  def mount(_params, %{"current_user_id" => user_id}, socket) do
    {:ok, current_user} = Identities.find_user(user_id)

    {:ok, assign(socket, current_user: current_user, count: 0)}
  end

  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: Routes.signup_path(socket, :index))}
  end

  @impl true
  def handle_event("inc", %{"diff" => value}, socket) do
    value = String.to_integer(value)
    socket = assign(socket, count: socket.assigns.count + value)
    {:noreply, socket}
  end
end
