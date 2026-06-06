defmodule Oxfmt.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/wingyplus/oxfmt_elixir"

  def project do
    [
      app: :oxfmt,
      version: @version,
      description: description(),
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:phoenix_live_view, "~> 1.2.0-rc", optional: true},
      {:rustler_precompiled, "~> 0.9"},
      {:rustler, "~> 0.38", optional: true}
    ]
  end

  defp description do
    "Elixir bindings and Phoenix LiveView tag formatter for oxc_formatter."
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      },
      files: package_files()
    ]
  end

  defp package_files do
    [
      "lib",
      "native/oxfmt_nif/.cargo",
      "native/oxfmt_nif/src",
      "native/oxfmt_nif/Cargo*",
      "mix.exs",
      "LICENSE",
      "README.md"
    ] ++ Path.wildcard("checksum-*.exs")
  end

  defp docs do
    [
      main: "Oxfmt",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
