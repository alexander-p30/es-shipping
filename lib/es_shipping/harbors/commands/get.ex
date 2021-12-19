defmodule EsShipping.Harbors.Commands.Get do
  @moduledoc false

  @behaviour EsShipping.Command

  @type t :: %__MODULE__{id: Ecto.UUID.t()}

  defstruct [:id]

  @impl true
  def new(%{id: id}), do: %__MODULE__{id: id}
end
