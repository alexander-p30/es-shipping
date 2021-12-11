defmodule EsShipping.InMemoryEventStoreCase do
  use ExUnit.CaseTemplate

  setup do
    {:ok, _apps} = Application.ensure_all_started(:es_shipping)

    on_exit(fn ->
      :ok = Application.stop(:es_shipping)
    end)
  end
end
