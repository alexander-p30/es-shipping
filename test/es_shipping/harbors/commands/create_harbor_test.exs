defmodule EsShipping.Harbors.Commands.CreateHarborTest do
  use EsShipping.DataCase, async: true

  alias EsShipping.Harbors.Commands.CreateHarbor

  describe "changeset/2" do
    test "return a valid changeset when all params are valid" do
      params = %CreateHarbor{name: "Hamburg Harbor", is_active: true, x_pos: 0, y_pos: 0}
      assert %Ecto.Changeset{valid?: true} = CreateHarbor.changeset(params)
    end

    test "return an invalid changeset when required params are missing" do
      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(%CreateHarbor{})

      assert %{
               is_active: ["can't be blank"],
               name: ["can't be blank"],
               x_pos: ["can't be blank"],
               y_pos: ["can't be blank"]
             } == errors_on(changeset)
    end

    test "return an invalid changeset when x_pos or y_pos is invalid" do
      params = %CreateHarbor{name: "Hamburg Harbor", is_active: true, x_pos: -1, y_pos: 0}
      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(params)
      assert %{x_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)

      params = %CreateHarbor{name: "Hamburg Harbor", is_active: true, x_pos: 0, y_pos: -1}
      assert %Ecto.Changeset{valid?: false} = changeset = CreateHarbor.changeset(params)
      assert %{y_pos: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end
end
