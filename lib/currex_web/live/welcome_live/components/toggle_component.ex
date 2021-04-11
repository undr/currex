defmodule CurrexWeb.WelcomeLive.ToggleComponent do
  use CurrexWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div
      id="<%= @id %>"
      phx-click="update"
      phx-value-name="<%= @id %>"
      phx-value-state="<%= opposite(@state) %>"
      phx-target="<%= @myself %>"
      class="app-toggle <%= outer_class(@state) %>"
    >
      <div class="app-toggle-inner-<%= exact(@state) %>"></div>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"name" => name, "state" => state}, socket) do
    send self(), {:"toggle_#{name}", %{state: bool(state)}}
    {:noreply, socket}
  end

  defp bool("on"),
    do: true
  defp bool("off"),
    do: false

  defp exact(true),
    do: "on"
  defp exact(false),
    do: "off"

  defp opposite(true),
    do: "off"
  defp opposite(false),
    do: "on"

  def outer_class(true),
    do: "bg-green-500"
  def outer_class(false),
    do: "bg-gray-300"
end
