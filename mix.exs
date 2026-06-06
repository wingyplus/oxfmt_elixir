defmodule Oxfmt.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :oxfmt,
      version: @version,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler_precompiled, "~> 0.9"},
      {:rustler, "~> 0.38", optional: true}
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "native/oxfmt_nif/.cargo",
        "native/oxfmt_nif/src",
        "native/oxfmt_nif/Cargo*",
        "checksum-*.exs",
        "mix.exs",
        "README.md"
      ]
    ]
  end
end
