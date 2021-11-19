# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :es_shipping,
  ecto_repos: [EsShipping.Repo],
  generators: [binary_id: true]

config :es_shipping, EsShipping.Application,
  pubsub: :local,
  registry: :local

config :es_shipping, EsShipping.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.Extreme,
    serializer: Commanded.Serialization.JsonSerializer,
    stream_prefix: "es_shipping",
    extreme: [
      db_type: :node,
      host: "localhost",
      port: 1113,
      username: "es_shipping",
      password: "ess",
      reconnect_delay: 2_000,
      max_attempts: :infinity
    ]
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

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
