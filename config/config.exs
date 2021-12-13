import Config

config :es_shipping,
  ecto_repos: [EsShipping.Repo],
  generators: [binary_id: true],
  event_stores: [EsShipping.EventSourcing.EventStore]

config :es_shipping, EsShipping.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id]

config :es_shipping, EsShipping.Application,
  pubsub: :local,
  registry: :local

config :es_shipping, EsShipping.EventSourcing.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: EsShipping.EventSourcing.EventStore
  ]

# Configures the endpoint
config :es_shipping, EsShippingWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: EsShippingWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: EsShipping.PubSub,
  live_view: [signing_salt: "dc0HBLbg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
