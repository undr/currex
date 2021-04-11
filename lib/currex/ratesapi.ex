defmodule Currex.Ratesapi do
  def get(currencies, base) do
    if base in currencies do
      resp = currencies
      |> List.delete(base)
      |> make_request(base)

      put_in(resp["rates"][base], 1.0)
    else
      make_request(currencies, base)
    end
  end

  defp make_request(currencies, base) do
    "https://api.ratesapi.io/api/latest"
    |> HTTPoison.get!(headers(), params: query(currencies, base))
    |> Map.fetch!(:body)
    |> Jason.decode!()
  end

  defp query(currencies, base),
    do: %{symbols: Enum.join(currencies, ","), base: base}

  defp headers,
    do: [{"Content-Type", "application/json;charset=utf-8"}]
end
