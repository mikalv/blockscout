defmodule Explorer.Validator.MetadataProcessor do
  @moduledoc """
  module to periodically retrieve and update metadata belonging to validators
  """
  use GenServer
  alias Explorer.Validator.{MetadataRetriever}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(args) do
    send(self(), :import_and_reschedule)
    IO.inspect("FDFF")
    {:ok, args}
  end

  @impl true
  def handle_info(:import_and_reschedule, state) do
    validators = MetadataRetriever.fetch_data()

    Explorer.Chain.import(%{validators: %{params: validators}}) |> IO.inspect()

    reschedule()

    {:noreply, state}
  end

  defp reschedule do
    Process.send_after(self(), :import_and_reschedule, :timer.hours(24))
  end
end

