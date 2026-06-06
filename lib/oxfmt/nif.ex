defmodule Oxfmt.NIF do
  @moduledoc false

  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :oxfmt,
    crate: "oxfmt_nif",
    base_url: "https://github.com/wingyplus/oxfmt/releases/download/v#{version}",
    force_build: System.get_env("OXFMT_BUILD") in ["1", "true"],
    version: version

  def format(_source, _opts), do: :erlang.nif_error(:nif_not_loaded)
end
