defmodule CurrexWeb.WelcomeLive.SelectorComponent do
  use CurrexWeb, :live_component

  @default [
    suggestions: [],
    items: [],
    query: "",
    placeholder: "Choose",
    selected: nil
  ]

  @impl true
  def mount(socket) do
    {:ok, assign(socket, @default)}
  end

  @impl true
  def update(assigns, socket) do
    socket = socket
    |> assign(:selected, assigns[:selected])
    |> assign(:suggestions, assigns[:items])
    |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"value" => query}, %{assigns: %{items: items}} = socket) do
    items = suggestions(items, query)
    {:noreply, assign(socket, suggestions: items)}
  end

  @impl true
  def handle_event("close", _, %{assigns: %{items: items}} = socket) do
    {:noreply, assign(socket, suggestions: items)}
  end

  @impl true
  def handle_event("select", %{"id" => id}, %{assigns: %{items: items, id: component}} = socket) do
    selected = item(items, id)
    send self(), {:"#{component}_selected", %{selected: selected}}
    {:noreply, assign(socket, suggestions: items, selected: selected)}
  end

  defp suggestions(items, ""),
    do: items
  defp suggestions(items, query),
    do: filter(items, String.downcase(query))

  defp filter(items, query) do
    Enum.filter(items, fn(item) ->
      [item.code | String.split(item.name)]
      |> Enum.map(&(String.downcase(&1)))
      |> Enum.any?(&(String.starts_with?(&1, query)))
    end)
  end

  defp dom_id(id),
    do: "selector-#{id}"

  defp item_id(id, code),
    do: "selector-#{id}-item-#{code}"

  defp title(nil),
    do: ""
  defp title(item),
    do: item.name

  defp item(items, code),
    do: Enum.find(items, &(&1.code == code))
end
