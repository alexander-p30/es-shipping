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

      assert %{"errors" => %{"name" => "can't be blank"}} ==
               ctx.conn |> post(@create_url, invalid_params) |> json_response(422)
    end

    test "return an error json with multiple errors when params are invalid", ctx do
      invalid_params = %{}

      assert %{
               "errors" => %{
                 "is_active" => "can't be blank",
                 "name" => "can't be blank",
                 "x_pos" => "can't be blank",
                 "y_pos" => "can't be blank"
               }
             } == ctx.conn |> post(@create_url, invalid_params) |> json_response(422)
    end
  end

  describe "PUT /harbors/:id/" do
    setup %{conn: conn} do
      create_params = json_params_for(:create_harbor, name: "Salvador", is_active: false)
      %{"id" => harbor_id} = conn |> post(@create_url, create_params) |> json_response(201)

      %{
        id: harbor_id,
        update_params:
          json_params_for(:update_harbor,
            name: "Porto Alegre",
            x_pos: 400,
            y_pos: 0
          )
      }
    end

    test "return a harbor json with updated fields when params are valid", ctx do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} =
        ctx.update_params

      assert %{
               "id" => ctx.id,
               "name" => name,
               "is_active" => is_active,
               "x_pos" => x_pos,
               "y_pos" => y_pos
             } == ctx.conn |> put(@update_url <> ctx.id, ctx.update_params) |> json_response(201)
    end

    test "return an error json with multiple errors when params are invalid", ctx do
      invalid_params = %{
        "id" => ctx.id,
        "name" => nil,
        "is_active" => nil,
        "x_pos" => -1,
        "y_pos" => -1
      }

      assert %{
               "errors" => %{
                 "is_active" => "can't be blank",
                 "name" => "can't be blank",
                 "x_pos" => "must be greater than or equal to 0",
                 "y_pos" => "must be greater than or equal to 0"
               }
             } == ctx.conn |> put(@update_url <> ctx.id, invalid_params) |> json_response(422)
    end

    test "return not found when id is not associated with any harbor", ctx do
      assert %{"errors" => "harbor_not_found"} ==
               ctx.conn
               |> put(@update_url <> Ecto.UUID.generate(), %{})
               |> json_response(404)
    end
  end

  describe "GET /harbors/:id/" do
    setup %{conn: conn} do
      harbor_attrs =
        :create_harbor |> build(name: "Salvador", is_active: false) |> Map.from_struct()

      %{"id" => harbor_id} =
        conn
        |> post(@create_url, json_params_for(:create_harbor, harbor_attrs))
        |> json_response(201)

      %{harbor: Map.put(harbor_attrs, :id, harbor_id)}
    end

    test "return a harbor json with the requested id", ctx do
      assert %{
               "id" => ctx.harbor.id,
               "name" => ctx.harbor.name,
               "is_active" => ctx.harbor.is_active,
               "x_pos" => ctx.harbor.x_pos,
               "y_pos" => ctx.harbor.y_pos
             } ==
               ctx.conn |> get(@show_url <> ctx.harbor.id) |> json_response(201)
    end

    test "return not found error when id is not associated with any harbor", ctx do
      assert %{"errors" => "harbor_not_found"} ==
               ctx.conn |> get(@show_url <> Ecto.UUID.generate()) |> json_response(404)
    end
  end
end
