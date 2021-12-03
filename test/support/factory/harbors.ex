defmodule EsShipping.Factory.Harbors do
  defmacro __using__(_) do
    quote do
      alias EsShipping.Harbors.Commands.CreateHarbor
      alias EsShipping.Harbors.Events.HarborCreated

      def create_harbor_factory(attrs) do
        command = %CreateHarbor{name: "a name", is_active: true, x_pos: 0, y_pos: 0}

        merge_attributes(command, attrs)
      end

      def harbor_created_factory(attrs) do
        event = %HarborCreated{name: "a name", is_active: true, x_pos: 0, y_pos: 0}

        merge_attributes(event, attrs)
      end
    end
  end
end
