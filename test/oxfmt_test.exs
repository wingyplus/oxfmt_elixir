defmodule OxfmtTest do
  use ExUnit.Case
  doctest Oxfmt

  test "formats JavaScript source code with the native formatter" do
    assert Oxfmt.format("const answer=1+1;") == {:ok, "const answer = 1 + 1;\n"}
  end
end
