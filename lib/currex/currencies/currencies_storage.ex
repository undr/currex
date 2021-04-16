defmodule Currex.Currencies.CurrenciesStorage do
  use Agent

  alias Currex.Currencies.Currency
  alias Currex.Currencies.Data

  def start_link(_arg) do
    state = Data.currencies()
    |> Enum.map(fn({code, name}) ->
      selected = code in Data.default_currency_codes()
      {code, %Currency{code: code, name: name, selected: selected}}
    end)
    |> Enum.into(%{})

    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def exists?(code),
    do: Agent.get(__MODULE__, fn(state) -> Map.has_key?(state, code) end)

  def all,
    do: Agent.get(__MODULE__, fn(state) -> Map.values(state) end)
  def all(selected: selected) do
    Agent.get(__MODULE__, fn(state) ->
      state
      |> Stream.map(fn({_code, currency}) -> currency end)
      |> Enum.filter(&(&1.selected == selected))
    end)
  end

  def get(code),
    do: Agent.get(__MODULE__, &(Map.get(&1, code)))

  def select(code),
    do: update(code, selected: true)

  def unselect(code),
    do: update(code, selected: false)

  defp update(code, attributes) do
    Agent.update(__MODULE__, fn(state) ->
      case Map.get(state, code) do
        nil ->
          state

        currency ->
          Map.put(state, code, Map.merge(currency, Enum.into(attributes, %{})))
      end
    end)
  end
end
