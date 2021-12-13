defmodule EsShipping.Storage do
  def reset! do
    reset_readstore!()
  end

  defp reset_readstore! do
    config = Application.get_env(:es_shipping, EsShipping.Repo)

    {:ok, conn} = Postgrex.start_link(config)

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
    TRUNCATE TABLE
      harbors,
      shipments,
      projection_versions
    RESTART IDENTITY
    CASCADE;
    """
  end
end
