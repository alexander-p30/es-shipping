defmodule EsShipping.Harbors.ContextTest do
  use EsShipping.InMemoryEventStoreCase, async: false

  import EsShipping.Factory

  alias EsShipping.Harbor
  alias EsShipping.Harbors.Context

  describe "create_harbor/1" do
    setup do
      %{params: json_params_for(:create_harbor)}
    end

    test "return an aggregate state when params are valid", %{params: params} do
      %{"name" => name, "is_active" => is_active, "x_pos" => x_pos, "y_pos" => y_pos} = params

      assert {:ok,
              %Harbor{
                id: id,
                name: ^name,
                is_active: ^is_active,
                x_pos: ^x_pos,
                y_pos: ^y_pos
              }} = Context.create_harbor(params)

      assert Ecto.UUID.cast!(id)
    end

    test "return error when name is invalid", %{params: params} do
      assert {:error, :must_have_name} ==
               params |> Map.put("name", nil) |> Context.create_harbor()

      assert {:error, :must_have_is_active} ==
               params |> Map.put("is_active", nil) |> Context.create_harbor()

      assert {:error, :x_pos_must_be_higher_than_0} ==
               params |> Map.put("x_pos", -40) |> Context.create_harbor()

      assert {:error, :y_pos_must_be_higher_than_0} ==
               params |> Map.put("y_pos", -1_273_182) |> Context.create_harbor()
    end
  end
end