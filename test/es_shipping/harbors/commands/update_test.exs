defmodule EsShipping.Harbors.Commands.UpdateTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands.Update

  describe "new/1" do
    setup do
      %{
        params: %{
          id: Ecto.UUID.generate(),
          name: "Malmö",
          is_active: true,
          x_pos: 13_112,
          y_pos: 1_029_818
        }
      }
    end

    test "return a update command struct with a list of received fields", %{params: params} do
      assert %Update{
               id: params.id,
               name: "Malmö",
               is_active: true,
               x_pos: 13_112,
               y_pos: 1_029_818,
               received_fields: ~w(name is_active x_pos y_pos)a
             } == Update.new(params)
    end

    test "return a update command struct with an empty list when only field is id" do
      params = %{id: Ecto.UUID.generate()}

      assert %Update{
               id: params.id,
               name: nil,
               is_active: nil,
               x_pos: nil,
               y_pos: nil,
               received_fields: []
             } == Update.new(params)
    end
  end
end
