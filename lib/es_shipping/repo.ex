defmodule EsShipping.Repo do
  use Ecto.Repo,
    otp_app: :es_shipping,
    adapter: Ecto.Adapters.Postgres
end
