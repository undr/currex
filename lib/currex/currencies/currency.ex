defmodule Currex.Currencies.Currency do
  defstruct [:code, :name, selected: false, rate: nil]
end
