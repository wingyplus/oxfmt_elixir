defmodule Oxfmt.NIF do
  @moduledoc false

  use Rustler, otp_app: :oxfmt, crate: :oxfmt_nif

  def format(_source), do: :erlang.nif_error(:nif_not_loaded)
end
