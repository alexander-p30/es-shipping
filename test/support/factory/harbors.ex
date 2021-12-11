defmodule EsShipping.Factory.Harbors do
  defmacro __using__(_) do
    quote do
      alias EsShipping.Harbor
      alias EsShipping.Harbors.Commands.CreateHarbor
      alias EsShipping.Harbors.Events.HarborCreated

      def harbor_factory(attrs) do
        harbor = %Harbor{name: "a name", is_active: true, x_pos: 0, y_pos: 0}

        merge_attributes(harbor, attrs)
      end

      def create_harbor_factory(attrs) do
        command = %CreateHarbor{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(command, attrs)
      end

      def harbor_created_factory(attrs) do
        event = %HarborCreated{
          id: Ecto.UUID.generate(),
          name: "a name",
          is_active: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(event, attrs)
      end
    end
  end
end
