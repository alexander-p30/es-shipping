defmodule EsShipping.Application do
  @moduledoc false

  use Application
  use Commanded.Application, otp_app: :es_shipping

  @impl true
  def start(_type, _args) do
    children = [
      EsShipping.Repo,
      EsShippingWeb.Telemetry,
      {Phoenix.PubSub, name: EsShipping.PubSub},
      EsShippingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EsShipping.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    EsShippingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
