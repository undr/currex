defmodule CurrexWeb.WelcomeLive.Index do
  use CurrexWeb, :live_view

  alias Currex.Currencies

  @default_base_code "USD"

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:all_currencies, Currencies.all_currencies())
    |> assign(:currencies, Currencies.unselected_currencies())
    |> assign(:rates, Currencies.rates(@default_base_code))
    |> assign(:base, Currencies.get(@default_base_code))
    |> assign(:refresh, false)

    {:ok, socket}
  end

  @impl true
  def handle_info({:toggle_refresh, %{state: state}}, socket),
    do: {:noreply, assign(socket, :refresh, state)}

  @impl true
  def handle_info({:currency_selected, %{selected: currency}}, socket) do
    Currencies.select(currency.code)

    socket = socket
    |> assign(:currencies, Currencies.unselected_currencies())
    |> assign(:rates, Currencies.rates(socket.assigns.base.code))

    {:noreply, socket}
  end

  @impl true
  def handle_info({:base_selected, %{selected: base}}, socket) do
    socket = socket
    |> assign(:rates, Currencies.rates(base.code))
    |> assign(:base, base)

    {:noreply, socket}
  end

  @impl true
  def handle_event("remove_category", %{"code" => code}, socket) do
    Currencies.unselect(code)

    socket = socket
    |> assign(:currencies, Currencies.unselected_currencies())
    |> assign(:rates, Currencies.rates(socket.assigns.base.code))

    {:noreply, socket}
  end

  @impl true
  def handle_event("refresh_rates", _, socket) do
    socket = socket
    |> assign(:currencies, Currencies.unselected_currencies())
    |> assign(:rates, Currencies.rates(socket.assigns.base.code))

    {:noreply, socket}
  end
end
