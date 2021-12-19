defmodule EsShippingWeb.Controllers.V1.HarborController do
  use EsShippingWeb, :controller

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Context

  def show(conn, params) do
    params
    |> Map.get("id")
    |> Context.get_harbor()
    |> send_response(conn)
  end

  def create(conn, params) do
    params
    |> Context.create_harbor()
    |> send_response(conn)
  end

  def update(conn, params) do
    params
    |> Context.update_harbor()
    |> send_response(conn)
  end

  defp send_response({:ok, %Harbor{} = harbor}, conn), do: send_json(conn, 201, harbor)

  defp send_response({:error, :harbor_not_found = reason}, conn),
    do: send_json(conn, 404, reason, entity: "harbor")

  defp send_response({:error, reason}, conn), do: send_json(conn, 422, reason, entity: "harbor")
end
