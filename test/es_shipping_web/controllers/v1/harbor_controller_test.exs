defmodule EsShippingWeb.Controllers.V1.HarborControllerTest do
  use EsShippingWeb.ConnCase, async: false

  import EsShipping.Factory

  @base_url "/api/v1/harbors"
  @create_url @base_url
  @update_url @base_url <> "/"
  @show_url @base_url <> "/"

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

  describe "PUT /harbors/:id/" do
    setup do
      %{
        create_params: json_params_for(:create_harbor, name: "Salvador", is_active: false),
        update_params: json_params_for(:update_harbor, name: "Porto Alegre", x_pos: 400, y_pos: 0)
      }
    end

    test "return a harbor json with updated fields when params are valid", ctx do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} =
        ctx.create_params

      assert %{
               "id" => id,
               "name" => ^name,
               "is_active" => ^is_active,
               "x_pos" => ^x_pos,
               "y_pos" => ^y_pos
             } = ctx.conn |> post(@create_url, ctx.create_params) |> json_response(201)

      assert Ecto.UUID.cast!(id)

      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} =
        ctx.update_params

      assert %{
               "id" => id,
               "name" => name,
               "is_active" => is_active,
               "x_pos" => x_pos,
               "y_pos" => y_pos
             } == ctx.conn |> put(@update_url <> id, ctx.update_params) |> json_response(201)
    end
  end

  describe "GET /harbors/:id/" do
    setup do
      %{create_params: json_params_for(:create_harbor, name: "Salvador", is_active: false)}
    end

    test "return a harbor json with updated fields when params are valid", ctx do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} =
        ctx.create_params

      assert %{
               "id" => id,
               "name" => ^name,
               "is_active" => ^is_active,
               "x_pos" => ^x_pos,
               "y_pos" => ^y_pos
             } = ctx.conn |> post(@create_url, ctx.create_params) |> json_response(201)

      assert Ecto.UUID.cast!(id)

      assert %{
               "id" => id,
               "name" => name,
               "is_active" => is_active,
               "x_pos" => x_pos,
               "y_pos" => y_pos
             } == ctx.conn |> get(@show_url <> id) |> json_response(201)
    end

    test "return not found error when id is not associated with any harbor", ctx do
      assert %{"entity" => "harbor", "error" => "harbor_not_found"} ==
               ctx.conn |> get(@show_url <> Ecto.UUID.generate()) |> json_response(404)
    end
  end
end
