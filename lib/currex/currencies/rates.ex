defmodule Currex.Currencies.Rates do
  alias Currex.Currencies.RatesCache

  def get([], _base),
    do: []
  def get(currencies, base) do
    incoming_rates = currencies
    |> Enum.map(fn(currency) -> currency.code end)
    |> RatesCache.get(base)

    Enum.map(currencies, fn(currency) -> %{currency | rate: Map.get(incoming_rates, currency.code) } end)
  end
end
