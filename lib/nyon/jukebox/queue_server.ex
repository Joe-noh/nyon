defmodule Nyon.Jukebox.QueueServer do
  use GenServer

  @name {:global, Nyon.Jukebox.QueueServer}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def queue do
    GenServer.call(@name, :queue)
  end

  def bulk_enqueue(spotify_account) do
    GenServer.call(@name, {:bulk_enqueue, spotify_account})
  end

  # callbacks

  def init(_) do
    {:ok, %{queue: []}}
  end

  def handle_call(:queue, _from, state = %{queue: queue}) do
    {:reply, queue, state}
  end

  def handle_call({:bulk_enqueue, _spotify_account}, _from, state = %{queue: []}) do
    queue = [
      %Sptfy.Object.FullTrack{uri: "spotify:track:2hKtLq0OFHoK7ftAqn456x"},
      %Sptfy.Object.FullTrack{uri: "spotify:track:5pZdWghXts7etZoYbL3WPU"}
    ]

    state = Map.put(state, :queue, queue)

    {:reply, :ok, state}
  end

  def handle_call({:bulk_enqueue, _spotify_account}, _from, state) do
    {:reply, :ok, state}
  end
end
