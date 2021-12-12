defmodule EsShipping.Harbors.Commands.CreateTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands.Create

  describe "new/1" do
    test "return a create command struct with a generated id" do
      params = %{name: "Malmö", is_active: true, x_pos: 13_112, y_pos: 1_029_818}

      assert %Create{id: id, name: "Malmö", is_active: true, x_pos: 13_112, y_pos: 1_029_818} =
               Create.new(params)

      assert Ecto.UUID.cast!(id)
    end
  end
end
