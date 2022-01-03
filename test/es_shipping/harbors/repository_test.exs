defmodule EsShipping.Harbors.RepositoryTest do
  use EsShipping.DataCase, async: false

  import EsShipping.Factory

  alias EsShipping.Harbors.Repository

  describe "get_by/1" do
    setup do
      harbors = Enum.map(0..2, &insert(:harbor_projection, x_pos: 0, y_pos: &1))

      %{harbors: harbors}
    end

    test "return existing projections matching the passed parameters", %{harbors: harbors} do
      assert harbors == Repository.get_by(x_pos: 0, is_active: true)

      assert Enum.filter(harbors, &(&1.y_pos == 2)) ==
               Repository.get_by(x_pos: 0, y_pos: 2, is_active: true)

      assert [] == Repository.get_by(name: "X", x_pos: 55, y_pos: 13_718, is_active: false)
    end
  end

  describe "unique_position?/2" do
    setup do
      %{harbor: insert(:harbor_projection)}
    end

    test "return true when coordinates match a database record", %{harbor: harbor} do
      refute Repository.unique_position?(harbor.x_pos, harbor.y_pos)
    end

    test "return false when coordinates do not match a database record" do
      assert Repository.unique_position?(987_654, 123_456)
    end
  end
end
