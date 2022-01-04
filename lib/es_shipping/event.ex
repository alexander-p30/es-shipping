defmodule EsShipping.Event do
  @moduledoc """
  Event type for executed commands.
  """

  alias EsShipping.Harbor
  alias EsShipping.Ship

  @type t() :: Harbor.event() | Ship.event()
end
