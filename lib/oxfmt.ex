defmodule Oxfmt do
  @moduledoc """
  JavaScript and TypeScript formatter powered by Oxc.
  """

  @option_defaults [
    indent_style: nil,
    indent_width: nil,
    line_ending: nil,
    line_width: nil,
    quote_style: nil,
    jsx_quote_style: nil,
    quote_properties: nil,
    trailing_commas: nil,
    semicolons: nil,
    arrow_parentheses: nil,
    bracket_spacing: nil,
    bracket_same_line: nil,
    attribute_position: nil,
    expand: nil,
    experimental_operator_position: nil,
    experimental_ternaries: nil,
    html_whitespace_sensitivity_ignore: nil,
    embedded_language_formatting: nil
  ]

  @doc """
  Formats JavaScript or TypeScript source code.

  ## Options

    * `:indent_style` - `:space` or `:tab`
    * `:indent_width` - integer from `0` to `24`
    * `:line_ending` - `:lf`, `:crlf`, or `:cr`
    * `:line_width` - integer from `1` to `320`
    * `:quote_style` - `:double` or `:single`
    * `:jsx_quote_style` - `:double` or `:single`
    * `:quote_properties` - `:as_needed`, `:preserve`, or `:consistent`
    * `:trailing_commas` - `:all`, `:es5`, or `:none`
    * `:semicolons` - `:always` or `:as_needed`
    * `:arrow_parentheses` - `:always` or `:as_needed`
    * `:bracket_spacing` - boolean
    * `:bracket_same_line` - boolean
    * `:attribute_position` - `:auto` or `:multiline`
    * `:expand` - `:auto` or `:never`
    * `:experimental_operator_position` - `:start` or `:end`
    * `:experimental_ternaries` - boolean
    * `:html_whitespace_sensitivity_ignore` - boolean
    * `:embedded_language_formatting` - `:auto` or `:off`

  ## Examples

      iex> Oxfmt.format("const answer=1+1;")
      {:ok, "const answer = 1 + 1;\\n"}

      iex> Oxfmt.format("const answer:number=1+1;")
      {:ok, "const answer: number = 1 + 1;\\n"}

      iex> Oxfmt.format("const answer=1+1;", semicolons: :as_needed)
      {:ok, "const answer = 1 + 1\\n"}

  """
  def format(source, opts \\ []) when is_binary(source) and is_list(opts) do
    with {:ok, opts} <- validate_options(opts) do
      Oxfmt.NIF.format(source, Map.new(opts))
    end
  end

  defp validate_options(opts) do
    with {:ok, opts} <- Keyword.validate(opts, @option_defaults) do
      opts =
        @option_defaults
        |> Keyword.merge(opts)
        |> Enum.map(fn
          {key, value} when is_atom(value) and not is_nil(value) -> {key, Atom.to_string(value)}
          option -> option
        end)

      {:ok, opts}
    end
  end
end
