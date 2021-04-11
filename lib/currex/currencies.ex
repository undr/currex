defmodule Currex.Currencies do
  alias Currex.Currencies.Rates
  alias Currex.Currencies.CurrenciesStorage

  def get(code) do
    CurrenciesStorage.get(code)
  end

  def all_currencies do
    CurrenciesStorage.all()
  end

  def selected_currencies do
    CurrenciesStorage.all(selected: true)
  end

  def unselected_currencies do
    CurrenciesStorage.all(selected: false)
  end

  def rates(base) do
    Rates.get(selected_currencies(), base)
  end

  def select(code) do
    CurrenciesStorage.select(code)
  end

  def unselect(code) do
    CurrenciesStorage.unselect(code)
  end
end
