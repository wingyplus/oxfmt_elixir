# Oxfmt

Elixir bindings for oxc_formatter.

Oxfmt uses precompiled Rustler NIFs from GitHub releases by default, so package
users do not need a local Rust toolchain. To force a local source build instead,
set `OXFMT_BUILD=true`.

```elixir
Oxfmt.format("const answer=1+1;")
# {:ok, "const answer = 1 + 1;\n"}

Oxfmt.format("const answer=1+1;", semicolons: :as_needed)
# {:ok, "const answer = 1 + 1\n"}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `oxfmt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:oxfmt, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/oxfmt>.

## Release

Precompiled NIF tarballs are built by GitHub Actions when a version tag is
pushed. After the artifacts are available, generate the checksum file before
publishing to Hex:

```sh
mix rustler_precompiled.download Oxfmt.NIF --all --print
```
