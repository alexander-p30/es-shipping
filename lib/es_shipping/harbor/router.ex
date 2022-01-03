defmodule EsShipping.Harbor.Router do
  use Commanded.Commands.Router

  alias EsShipping.Harbor
  alias EsShipping.Harbor.Commands.Create
  alias EsShipping.Harbor.Commands.Get
  alias EsShipping.Harbor.Commands.Update

  identify(Harbor, by: :id)

  dispatch([Create, Get, Update], to: Harbor)
end
