defmodule Currex.Currencies.RatesCache do
  use GenServer

  require Logger

  alias Currex.Currencies.Data
  alias Currex.Ratesapi

  @cache_ttl 60 * 60 * 1000

  defmodule Cache do
    defstruct [:timer, rates: %{}]
  end

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_arg) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def get(currencies, base),
    do: GenServer.call(__MODULE__, {:get, currencies, base})

  def handle_call({:get, currencies, base}, _from, state) do
    case state do
      %{^base => cache} ->
        {:reply, Map.take(cache.rates, currencies), state}

      _ ->
        case Ratesapi.get(Data.currency_codes(), base) do
          %{"rates" => rates} ->
            cache = set_timer(%Cache{rates: rates}, base)

            {:reply, Map.take(rates, currencies), Map.put(state, base, cache)}

          _ ->
            {:reply, %{}, state}
        end
    end
  end

  def handle_info({:clear, base}, state) do
    Logger.debug("Clear currency rates cache for #{base}")

    case state do
      %{^base => cache} ->
        cancel_timer(cache)
        {:noreply, Map.delete(state, base)}

      _ ->
        {:noreply, state}
    end
  end

  def handle_info({:DOWN, _ref, :process, _, _}, state) do
    {:noreply, clear_all(state)}
  end

  def handle_info({:EXIT, _pid, :client_down}, state) do
    {:noreply, clear_all(state)}
  end

  def terminate(_reason, state) do
    clear_all(state)
  end

  defp clear_all(state) do
    Enum.each(state, fn(_, cache) -> cancel_timer(cache) end)
    %{}
  end

  defp cancel_timer(cache) do
    Process.cancel_timer(cache.timer)
    %{cache | timer: nil}
  end

  defp set_timer(cache, base) do
    timer = Process.send_after(self(), {:clear, base}, @cache_ttl)
    %{cache | timer: timer}
  end
end
