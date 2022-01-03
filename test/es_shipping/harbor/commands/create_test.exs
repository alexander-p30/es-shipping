defmodule EsShipping.Harbor.Commands.CreateTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Harbor.Commands.Create

  describe "new/1" do
    test "return a create command struct with a generated id" do
      params = %{name: "Malmö", is_active: true, x_pos: 13_112, y_pos: 1_029_818}

      assert %Create{id: id, name: "Malmö", is_active: true, x_pos: 13_112, y_pos: 1_029_818} =
               Create.new(params)

      assert Ecto.UUID.cast!(id)
    end
  end

  describe "implementation of validate" do
    setup do
      %{command: build(:create_harbor)}
    end

    test "return create struct when all params are valid", %{command: command} do
      assert {:ok, command} == Command.validate(command)
    end

    test "return invalid changeset when coordinates are invalid", %{command: command} do
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               put_in(command.x_pos, -1) |> Command.validate()

      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)

      assert {:error, %Ecto.Changeset{valid?: false} = changeset} =
               put_in(command.y_pos, -1) |> Command.validate()

      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return invalid changeset when coordinates are not unique", %{command: command} do
      params = command |> Map.from_struct() |> Map.drop([:received_fields])
      insert(:harbor_projection, params)

      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(command)
    end
  end
end
