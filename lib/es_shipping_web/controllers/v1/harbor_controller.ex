defmodule EsShippingWeb.Controllers.V1.HarborController do
  use EsShippingWeb, :controller

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Context

  def create(conn, params) do
    params
    |> Context.create_harbor()
    |> case do
      {:ok, %Harbor{} = harbor} -> send_json(conn, 201, harbor)
      {:error, reason} -> send_json(conn, 422, reason, entity: "harbor")
    end
  end
end
