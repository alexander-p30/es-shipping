defmodule EsShippingWeb.Router do
  use EsShippingWeb, :router

  alias Controllers.V1

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", EsShippingWeb do
    pipe_through :api

    resources "/harbors", V1.HarborController, only: [:create]
  end
end
