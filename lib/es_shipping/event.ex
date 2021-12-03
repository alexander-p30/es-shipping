defmodule EsShipping.Event do
  @moduledoc """
  Event type for executed commands.
  """

  alias EsShipping.Harbor

  @type t() :: Harbor.harbor_event()
end
