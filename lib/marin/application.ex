defmodule Marin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    unless Mix.env() == :test do
      start_job_queue()
    end

    start_application()
  end

  defp start_application() do
    children = [
      Marin.Repo,
      MarinWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Marin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_job_queue do
    tree = [supervisor(Verk.Supervisor, [])]
    opts = [name: Simple.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MarinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
