defmodule CurrexWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `CurrexWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, CurrexWeb.CurrencyLive.FormComponent,
        id: @currency.id || :new,
        action: @live_action,
        currency: @currency,
        return_to: Routes.currency_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, CurrexWeb.ModalComponent, modal_opts)
  end
end
