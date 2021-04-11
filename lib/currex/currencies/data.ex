defmodule Currex.Currencies.Data do
  @currencies [File.cwd!(), "priv/data/currencies.json"]
    |> Path.join()
    |> File.read!()
    |> Jason.decode!()

  def currencies,
    do: @currencies

  def currency_codes,
    do: Enum.map(currencies(), &(elem(&1, 0)))
end
