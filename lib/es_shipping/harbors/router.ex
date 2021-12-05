defmodule EsShipping.Harbors.Router do
  use Commanded.Commands.Router

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Commands.CreateHarbor

  dispatch(CreateHarbor, to: Harbor, identity: :name)
end
