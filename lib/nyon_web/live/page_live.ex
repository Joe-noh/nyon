defmodule NyonWeb.PageLive do
  use NyonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{}, count: 0)}
  end

  @impl true
  def handle_event("inc", %{"diff" => value}, socket) do
    value = String.to_integer(value)
    socket = assign(socket, count: socket.assigns.count + value)
    {:noreply, socket}
  end
end
