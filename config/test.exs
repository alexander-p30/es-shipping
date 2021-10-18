import Config

config :es_shipping, EsShipping.Repo,
  username: "es_shipping_db",
  password: "es_shipping_pass",
  database: "es_shipping_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :es_shipping, EsShippingWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CGWBhXp3x+eI9MGmk8t3f9WIuzs5vbFi4XGMAfoNx9An/lvyMETSBtMXNbm+3fBS",
  server: false

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
