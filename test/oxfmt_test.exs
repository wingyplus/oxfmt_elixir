defmodule OxfmtTest do
  use ExUnit.Case
  doctest Oxfmt

  test "formats JavaScript source code with the native formatter" do
    assert Oxfmt.format("const answer=1+1;") == {:ok, "const answer = 1 + 1;\n"}
  end

  test "formats with keyword options" do
    assert Oxfmt.format("const answer=1+1;", semicolons: :as_needed) ==
             {:ok, "const answer = 1 + 1\n"}
  end

  test "formats with default keyword options" do
    assert Oxfmt.format("const answer=1+1;", []) == {:ok, "const answer = 1 + 1;\n"}
  end

  test "rejects unknown options" do
    assert Oxfmt.format("const answer=1+1;", unknown: true) ==
             {:error, [:unknown]}
  end

  test "rejects invalid option values" do
    assert Oxfmt.format("const answer=1+1;", semicolons: :never) ==
             {:error, "invalid semicolons: never; expected always or as_needed"}
  end
end
