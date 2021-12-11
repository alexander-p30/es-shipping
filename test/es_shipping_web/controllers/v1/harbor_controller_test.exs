defmodule EsShippingWeb.Controllers.V1.HarborControllerTest do
  use EsShippingWeb.ConnCase, async: true

  import EsShipping.Factory

  @base_url "/api/v1/harbors"
  @create_url @base_url

  describe "POST /harbors" do
    setup do
      %{params: json_params_for(:create_harbor, name: "Salvador", is_active: false)}
    end

    test "return a harbor json when params are valid", ctx do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} = ctx.params

      assert %{
               "id" => id,
               "name" => ^name,
               "is_active" => ^is_active,
               "x_pos" => ^x_pos,
               "y_pos" => ^y_pos
             } = ctx.conn |> post(@create_url, ctx.params) |> json_response(201)

      assert Ecto.UUID.cast!(id)
    end

    test "return an error json when name is invalid", ctx do
      invalid_params = Map.put(ctx.params, "name", nil)

      assert %{"error" => "must_have_name", "entity" => "harbor"} =
               ctx.conn |> post(@create_url, invalid_params) |> json_response(422)
    end
  end
end
