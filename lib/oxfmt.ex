defmodule Oxfmt do
  @moduledoc """
  JavaScript formatter powered by Oxc.
  """

  @doc """
  Formats JavaScript source code.

  ## Examples

      iex> Oxfmt.format("const answer=1+1;")
      {:ok, "const answer = 1 + 1;\\n"}

  """
  def format(source) when is_binary(source) do
    Oxfmt.NIF.format(source)
  end
end
