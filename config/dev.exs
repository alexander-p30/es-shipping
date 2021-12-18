import Config

config :es_shipping, EsShipping.Repo,
  username: "es_shipping_db",
  password: "es_shipping_pass",
  database: "es_shipping_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :es_shipping, EsShippingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "BzDpJUtJzxtpR1SiHaou1wX8Ald/76g9Xxx57pdRWkn7icArjrtTZJOW8TjVxQBE",
  watchers: []

config :es_shipping, EsShipping.EventSourcing.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "event_store_db",
  password: "event_store_pass",
  database: "event_store_db",
  hostname: "localhost",
  port: "2113",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
