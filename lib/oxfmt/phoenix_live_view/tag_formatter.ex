case Code.ensure_compiled(Phoenix.LiveView.HTMLFormatter.TagFormatter) do
  {:module, Phoenix.LiveView.HTMLFormatter.TagFormatter} ->
    defmodule Oxfmt.Phoenix.LiveView.TagFormatter do
      @moduledoc """
      Phoenix LiveView tag formatter for JavaScript inside HEEx `<script>` tags.

      Register this module with `Phoenix.LiveView.HTMLFormatter`:

          [
            plugins: [Phoenix.LiveView.HTMLFormatter],
            tag_formatters: %{script: Oxfmt.Phoenix.LiveView.TagFormatter}
          ]

      Oxfmt options can be passed through the formatter options:

          [
            tag_formatters: %{script: Oxfmt.Phoenix.LiveView.TagFormatter},
            oxfmt: [semicolons: :as_needed]
          ]

      The module is only compiled when
      `Phoenix.LiveView.HTMLFormatter.TagFormatter` is available.
      """

      @behaviour Phoenix.LiveView.HTMLFormatter.TagFormatter

      require Logger

      @impl true
      def render_tag({"script", attrs, content}, opts) when not is_map_key(attrs, "runtime") do
        case Oxfmt.format(content, Keyword.get(opts, :oxfmt, [])) do
          {:ok, formatted} ->
            {:ok, String.trim(formatted)}

          {:error, reason} ->
            Logger.error("Failed to format with oxfmt: #{inspect(reason)}")
            :skip
        end
      end

      def render_tag({_tag, _attrs, _content}, _opts) do
        :skip
      end
    end

  _error ->
    nil
end
