defmodule CurrexWeb.WelcomeLive.CurrencyCardComponent do
  use CurrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @currency.code %>" class="app-currency">
      <div class="app-currency-code">
        <div class="app-currency-code-circle">
          <span><%= @currency.code %></span>
        </div>
      </div>
      <div class="app-currency-title"><%= @currency.name %></div>
      <div class="app-currency-rate"><%= @currency.rate %></div>
      <button
        class="app-currency-remove"
        phx-click="remove_category"
        phx-value-code="<%= @currency.code %>"
      >
        <i class="far fa-trash-alt"></i>
      </button>
    </div>
    """
  end
end
