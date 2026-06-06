# Oxfmt

Elixir bindings for oxc_formatter

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
