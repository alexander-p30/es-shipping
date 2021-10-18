defmodule EsShippingWeb.Router do
  use EsShippingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EsShippingWeb do
    pipe_through :api
  end
end
