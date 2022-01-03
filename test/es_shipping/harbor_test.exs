defmodule EsShipping.HarborTest do
  use EsShipping.DataCase, async: true

  import EsShipping.Factory

  alias EsShipping.Harbor

  @create_attrs %{
    id: Ecto.UUID.generate(),
    name: "Sydney",
    is_active: true,
    x_pos: 238,
    y_pos: 101_010
  }

  @update_attrs %{
    id: Ecto.UUID.generate(),
    name: "Dunkerque",
    is_active: false,
    x_pos: 81_731,
    y_pos: 2833
  }

  @get_attrs @create_attrs

  setup_all do
    %{
      create_command: build(:create_harbor, @create_attrs),
      create_event: build(:harbor_created, @create_attrs),
      update_command: build(:update_harbor, @update_attrs),
      update_event: build(:harbor_updated, @update_attrs),
      get_command: build(:get_harbor, id: @get_attrs.id),
      get_event: build(:harbor_got, @get_attrs)
    }
  end

  describe "execute/2" do
    test "return harbor created event when create harbor command is valid", ctx do
      assert ctx.create_event == Harbor.execute(%Harbor{}, ctx.create_command)
    end

    test "return a changeset when create harbor command is invalid", ctx do
      ctx = put_in(ctx.create_command.name, nil)

      assert {:error, {:validation, %Ecto.Changeset{valid?: false}}} =
               Harbor.execute(%Harbor{}, ctx.create_command)
    end

    test "raise when identity field is not nil and command is create harbor", ctx do
      assert_raise FunctionClauseError, fn ->
        Harbor.execute(%Harbor{id: Ecto.UUID.generate()}, ctx.create_command)
      end
    end

    test "return harbor updated event when update harbor command is valid", ctx do
      assert ctx.update_event ==
               Harbor.execute(%Harbor{id: ctx.update_command.id}, ctx.update_command)
    end

    test "return an error atom when update harbor command is invalid", ctx do
      ctx = put_in(ctx.update_command.name, nil)

      assert {:error, {:validation, %Ecto.Changeset{valid?: false} = changeset}} =
               Harbor.execute(%Harbor{id: ctx.update_command.id}, ctx.update_command)

      assert %{name: ["can't be blank"]} == errors_on(changeset)
    end

    test "return harbor not found when identity does not match in update", ctx do
      put_in(ctx.update_command.id, Ecto.UUID.generate())

      assert {:error, {:internal, :harbor_not_found}} ==
               Harbor.execute(%Harbor{id: Ecto.UUID.generate()}, ctx.update_command)
    end

    test "return harbor got event with requested id when get command is valid", ctx do
      Harbor.execute(%Harbor{}, ctx.create_command)
      updated_aggregate = build(:harbor, @create_attrs)

      assert ctx.get_event == Harbor.execute(updated_aggregate, ctx.get_command)
    end

    test "return harbor not found error when get command is invalid", ctx do
      Harbor.execute(%Harbor{}, ctx.create_command)
      updated_aggregate = build(:harbor, @create_attrs)

      assert {:error, {:internal, :harbor_not_found}} ==
               Harbor.execute(updated_aggregate, build(:get_harbor, id: Ecto.UUID.generate()))
    end
  end

  describe "apply/2" do
    test "return a mutated harbor struct with created event attributes", ctx do
      mutated_harbor = build(:harbor, @create_attrs)

      assert mutated_harbor == Harbor.apply(%Harbor{}, ctx.create_event)
    end

    test "return a mutated harbor struct with updated event attributes", ctx do
      mutated_harbor = build(:harbor, @update_attrs)

      assert mutated_harbor == Harbor.apply(%Harbor{id: ctx.update_event.id}, ctx.update_event)
    end

    test "return a non-mutated harbor when event is got" do
      unchanged_harbor = build(:harbor, @create_attrs)

      got_event =
        build(:harbor_got,
          id: @create_attrs.id,
          name: "Some other name",
          x_pos: 999,
          y_pos: 1000
        )

      assert unchanged_harbor == Harbor.apply(unchanged_harbor, got_event)
    end
  end
end
