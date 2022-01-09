defmodule EsShipping.Ship.Commands.MoveTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.Command
  alias EsShipping.Ship.Commands.Move
  alias EsShipping.Ship.Events.Moved

  @id Ecto.UUID.generate()

  describe "new/1" do
    test "return a move struct with passed params" do
      assert %Move{id: @id, x_pos: 109, y_pos: 287, received_coordinates: [:x_pos, :y_pos]} ==
               Move.new(%{id: @id, x_pos: 109, y_pos: 287})
    end
  end

  describe "implementation of validation" do
    setup do
      %{command: build(:move_ship)}
    end

    test "return move struct when params are valid", %{command: command} do
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

    test "only validate coordinates present in 'received_coordinates' field", %{command: command} do
      coordinates = [:x_pos, :y_pos]

      for coordinate <- coordinates, invalid_value <- [-1, nil] do
        command =
          command
          |> Map.put(coordinate, invalid_value)
          |> Map.put(:received_coordinates, coordinates -- [coordinate])

        assert {:ok, %Move{}} = Command.validate(command)
      end
    end
  end

  describe "implementation of conversion" do
    setup do
      %{
        command: build(:move_ship, id: @id),
        aggregate: build(:ship, id: @id, x_pos: 888, y_pos: 999)
      }
    end

    test "return moved event", %{command: command, aggregate: aggregate} do
      assert %Moved{
               id: command.id,
               x_pos: command.x_pos,
               y_pos: command.y_pos,
               updated_coordinates: [:x_pos, :y_pos]
             } == Command.to_event(command, aggregate)
    end

    test "return moved event and with coordinates from event only when they're " <>
           "present in 'updated_coordinates'",
         %{command: command, aggregate: aggregate} do
      command = put_in(command.received_coordinates, [])
      assert command.x_pos != aggregate.x_pos
      assert command.y_pos != aggregate.y_pos

      assert %Moved{
               id: command.id,
               x_pos: aggregate.x_pos,
               y_pos: aggregate.y_pos,
               updated_coordinates: []
             } == Command.to_event(command, aggregate)

      command = put_in(command.received_coordinates, [:x_pos])

      assert %Moved{
               id: command.id,
               x_pos: command.x_pos,
               y_pos: aggregate.y_pos,
               updated_coordinates: [:x_pos]
             } == Command.to_event(command, aggregate)
    end
  end
end
