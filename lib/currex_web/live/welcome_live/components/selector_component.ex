defmodule CurrexWeb.WelcomeLive.SelectorComponent do
  use CurrexWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, suggestions: [], query: "")}
  end

  @impl true
  def update(assigns, socket) do
    socket = socket
    |> assign(:query, query(assigns[:selected]))
    |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"query" => query}, socket) do
    items = suggestions(socket.assigns.items, query)
    {:noreply, assign(socket, suggestions: items, query: query)}
  end

  @impl true
  def handle_event("select", %{"id" => id}, socket) do
    selected = item(socket.assigns.items, id)
    send self(), {:"#{socket.assigns.id}_selected", %{selected: selected}}
    {:noreply, assign(socket, suggestions: [], query: query(selected))}
  end

  @impl true
  def handle_event("toggle_items", _, %{assigns: %{suggestions: suggestions, items: items}} = socket) do
    {:noreply, assign(socket, :suggestions, toggle_items(suggestions, items))}
  end

  @impl true
  def handle_event("focus", _, %{assigns: %{items: items}} = socket) do
    socket = socket
    |> assign(:suggestions, items)
    |> assign(:query, "")

    {:noreply, socket}
  end

  @impl true
  def handle_event("blur", _, %{assigns: %{selected: item}} = socket) do
    socket = socket
    |> assign(:suggestions, [])
    |> assign(:query, query(item))

    {:noreply, socket}
  end

  defp toggle_items([], items),
    do: items
  defp toggle_items(_suggestions, _items),
    do: []

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

  defp chevron_class(suggestions) do
    if Enum.empty?(suggestions) do
      "fas fa-chevron-down"
    else
      "fas fa-chevron-up"
    end
  end

  defp query(nil),
    do: ""
  defp query(item),
    do: item.name

  defp item(items, code),
    do: Enum.find(items, &(&1.code == code))
end
