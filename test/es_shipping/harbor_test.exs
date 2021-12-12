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

  setup_all do
    %{
      create_command: build(:create_harbor, @create_attrs),
      create_event: build(:harbor_created, @create_attrs),
      update_command: build(:update_harbor, @update_attrs),
      update_event: build(:harbor_updated, @update_attrs)
    }
  end

  describe "execute/2" do
    test "return harbor created event when create harbor command is valid", ctx do
      assert ctx.create_event == Harbor.execute(%Harbor{}, ctx.create_command)
    end

    test "return an error atom when create harbor command is invalid", ctx do
      ctx = put_in(ctx.create_command.name, nil)
      assert {:error, :must_have_name} == Harbor.execute(%Harbor{}, ctx.create_command)
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

      assert {:error, :must_have_name} ==
               Harbor.execute(%Harbor{id: ctx.update_command.id}, ctx.update_command)
    end

    test "raise when identity field is nil and command is update harbor", ctx do
      assert_raise FunctionClauseError, fn ->
        Harbor.execute(%Harbor{id: nil}, ctx.update_command)
      end
    end
  end

  describe "apply/2" do
    test "return a mutated harbor struct with created event attributes ", ctx do
      mutated_harbor = %Harbor{
        id: ctx.create_event.id,
        name: ctx.create_event.name,
        is_active: ctx.create_event.is_active,
        x_pos: ctx.create_event.x_pos,
        y_pos: ctx.create_event.y_pos
      }

      assert mutated_harbor == Harbor.apply(%Harbor{}, ctx.create_event)
      assert mutated_harbor == Harbor.apply(%Harbor{name: ctx.create_event}, ctx.create_event)
    end

    test "return a mutated harbor struct with updated event attributes ", ctx do
      mutated_harbor = %Harbor{
        id: ctx.update_event.id,
        name: ctx.update_event.name,
        is_active: ctx.update_event.is_active,
        x_pos: ctx.update_event.x_pos,
        y_pos: ctx.update_event.y_pos
      }

      assert mutated_harbor == Harbor.apply(%Harbor{id: ctx.update_event.id}, ctx.update_event)

      assert mutated_harbor ==
               Harbor.apply(
                 %Harbor{id: ctx.update_event.id, name: ctx.update_event.name},
                 ctx.update_event
               )
    end
  end
end
