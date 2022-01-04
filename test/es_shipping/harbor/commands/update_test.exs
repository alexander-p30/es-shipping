defmodule EsShipping.Harbor.Commands.UpdateTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Harbor.Commands.Update
  alias EsShipping.Harbor.Events.Updated

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

  describe "implementation of validation" do
    setup do
      %{command: build(:update_harbor)}
    end

    test "return update struct when all params are valid", %{command: command} do
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

    test "return invalid changeset when a coordinate is missing", %{command: command} do
      command = %Update{command | x_pos: nil, received_fields: [:y_pos]}
      assert {:error, %Ecto.Changeset{valid?: false} = changeset} = Command.validate(command)

      assert %{y_pos: ["coordinates must come in pairs"]} == errors_on(changeset)
    end

    test "return invalid changeset when coordinates are not unique", %{command: command} do
      params = command |> Map.from_struct() |> Map.drop([:received_fields])
      insert(:harbor_projection, params)

      assert {:error, %Ecto.Changeset{valid?: false}} = Command.validate(command)
    end
  end

  describe "implementation of conversion" do
    setup do
      %{command: build(:update_harbor)}
    end

    test "return a updated event", %{command: command} do
      assert %Updated{
               id: command.id,
               name: command.name,
               is_active: command.is_active,
               x_pos: command.x_pos,
               y_pos: command.y_pos
             } == Command.to_event(command, nil)
    end
  end
end
