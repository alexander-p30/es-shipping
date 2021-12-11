defmodule EsShipping.Harbors.Commands.CreateHarborTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands.CreateHarbor

  describe "changeset/2" do
    setup do
      command = %CreateHarbor{
        id: Ecto.UUID.generate(),
        name: "Hamburg Harbor",
        is_active: true,
        x_pos: 0,
        y_pos: 0
      }

      %{command: command}
    end

    test "return a valid changeset with an id when all params are valid", %{command: command} do
      assert %Ecto.Changeset{valid?: true} = CreateHarbor.changeset(command)
    end

    test "return an invalid changeset with no id when required params are missing" do
      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(%CreateHarbor{})

      assert %{
               id: ["can't be blank"],
               name: ["can't be blank"],
               is_active: ["can't be blank"],
               x_pos: ["can't be blank"],
               y_pos: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "return an invalid changeset when x_pos is invalid", %{command: command} do
      command = %CreateHarbor{command | x_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(command)
      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end

    test "return an invalid changeset when y_pos is invalid", %{command: command} do
      command = %CreateHarbor{command | y_pos: -1}

      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(command)
      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end
end
