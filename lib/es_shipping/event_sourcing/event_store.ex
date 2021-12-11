defmodule EsShipping.EventSourcing.EventStore do
  @moduledoc false

  use EventStore, otp_app: :es_shipping
end
