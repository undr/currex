defmodule Currex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CurrexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Currex.PubSub},
      # Start the Endpoint (http/https)
      CurrexWeb.Endpoint
      # Start a worker by calling: Currex.Worker.start_link(arg)
      # {Currex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Currex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CurrexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
