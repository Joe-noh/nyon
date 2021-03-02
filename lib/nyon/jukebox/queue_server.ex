defmodule Nyon.Jukebox.QueueServer do
  use GenServer

  alias Nyon.Jukebox

  @name {:global, Nyon.Jukebox.QueueServer}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def queue do
    GenServer.call(@name, :queue)
  end

  def clear_queue do
    GenServer.call(@name, :clear_queue)
  end

  def enqueue_recommends(spotify_account) do
    GenServer.call(@name, {:enqueue_recommends, spotify_account})
  end

  # callbacks

  def init(_) do
    {:ok, %{queue: []}}
  end

  def handle_call(:queue, _from, state = %{queue: queue}) do
    {:reply, queue, state}
  end

  def handle_call(:clear_queue, _from, state) do
    {:reply, :ok, Map.put(state, :queue, [])}
  end

  def handle_call({:enqueue_recommends, spotify_account}, _from, state = %{queue: []}) do
    case Jukebox.Spotify.get_recommends(spotify_account) do
      {:ok, tracks} ->
        {:reply, :ok, Map.put(state, :queue, tracks)}

      {:error, _reason} ->
        {:reply, :ok, state}
    end
  end

  def handle_call({:enqueue_recommends, _spotify_account}, _from, state) do
    {:reply, :ok, state}
  end
end
