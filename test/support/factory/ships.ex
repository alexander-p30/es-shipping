defmodule EsShipping.Factory.Ships do
  defmacro __using__(_) do
    quote do
      def ship_factory(attrs) do
        ship = %EsShipping.Ship{
          name: "HMS Something",
          is_active: true,
          is_docked: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(ship, attrs)
      end

      def create_ship_factory(attrs) do
        command = %EsShipping.Ship.Commands.Create{
          id: Ecto.UUID.generate(),
          name: "Flying Dutchman",
          is_active: true,
          is_docked: true,
          x_pos: 0,
          y_pos: 0
        }

        merge_attributes(command, attrs)
      end
    end
  end
end
