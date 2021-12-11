defmodule EsShipping.Harbors.Router do
  use Commanded.Commands.Router

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.Create

  dispatch(Create, to: Harbor, identity: :id)
end
