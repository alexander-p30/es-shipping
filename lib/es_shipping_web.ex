defmodule EsShippingWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use EsShippingWeb, :controller
      use EsShippingWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: EsShippingWeb

      import Plug.Conn
      alias EsShippingWeb.Router.Helpers, as: Routes

      defp send_json(conn, status, body, details \\ [])

      defp send_json(conn, status, body, details) when status >= 400 do
        content = details |> Map.new() |> Map.merge(%{errors: body})

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(status, Jason.encode!(content))
      end

      defp send_json(conn, status, body, _details) do
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(status, Jason.encode!(body))
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/es_shipping_web/templates",
        namespace: EsShippingWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import EsShippingWeb.ErrorHelpers
      alias EsShippingWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
