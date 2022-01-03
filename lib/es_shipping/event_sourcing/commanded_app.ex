defmodule EsShipping.EventSourcing.CommandedApp do
  @moduledoc false

  use Commanded.Application, otp_app: :es_shipping

  router(EsShipping.Harbor.Router)
end
