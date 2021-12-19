defmodule EsShipping.Command.Validations do
  @moduledoc """
  Routes commands to command validation modules,
  according to their responsible entity.
  """

  alias EsShipping.Command
  alias EsShipping.Harbors.Commands, as: HarborCommands
  alias EsShipping.Harbors.Commands.Create, as: CreateHarbor
  alias EsShipping.Harbors.Commands.Get, as: GetHarbor
  alias EsShipping.Harbors.Commands.Update, as: UpdateHarbor

  @harbor_commands [CreateHarbor, GetHarbor, UpdateHarbor]

  @spec validate(command :: Command.t()) :: {:ok, Command.t()} | {:error, Ecto.Changeset.t()}
  def validate(command) do
    command
    |> get_validator()
    |> then(& &1.validate(command))
    |> case do
      %Ecto.Changeset{valid?: true} -> {:ok, command}
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end

  @spec get_validator(command :: Command.t()) :: module()
  def get_validator(%command{}) when command in @harbor_commands, do: HarborCommands
end
