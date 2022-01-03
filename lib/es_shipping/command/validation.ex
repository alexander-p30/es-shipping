defprotocol EsShipping.Command.Validation do
  @spec validate(command :: struct) :: {:ok, struct()} | {:error, Ecto.Changeset.t()}
  def validate(command)
end
