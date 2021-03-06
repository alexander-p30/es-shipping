defmodule EsShippingWeb.Controllers.V1.HarborController do
  use EsShippingWeb, :controller

  alias EsShipping.Harbor
  alias EsShipping.Harbor.Context

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

  defp send_response({:error, {:internal, :harbor_not_found = reason}}, conn),
    do: send_json(conn, 404, reason)

  defp send_response({:error, {:validation, changeset}}, conn),
    do: send_json(conn, 422, get_changeset_errors(changeset))
end
