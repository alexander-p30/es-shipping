defprotocol EsShipping.Command.Conversion do
  alias EsShipping.Command
  alias EsShipping.Event

  @spec to_event(command :: Command.t(), aggregate :: Command.aggregate()) :: Event.t()
  def to_event(command, aggregate)
end
