defmodule EsShipping.Harbors.Router do
  use Commanded.Commands.Router

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.Create
  alias EsShipping.Harbors.Commands.Update

  identify(Harbor, by: :id)

  dispatch([Create, Update], to: Harbor)
end
