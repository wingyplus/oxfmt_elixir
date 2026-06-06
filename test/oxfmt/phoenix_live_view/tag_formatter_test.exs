defmodule Oxfmt.Phoenix.LiveView.TagFormatterTest do
  use ExUnit.Case, async: true

  alias Oxfmt.Phoenix.LiveView.TagFormatter

  @moduletag :capture_log

  test "formats script tags through Phoenix LiveView HTMLFormatter" do
    assert Phoenix.LiveView.HTMLFormatter.format(
             "<script>const answer=1+1;</script>",
             tag_formatters: %{script: TagFormatter}
           ) == """
           <script>
             const answer = 1 + 1;
           </script>
           """
  end

  test "passes oxfmt options from HTMLFormatter opts" do
    assert Phoenix.LiveView.HTMLFormatter.format(
             "<script>const answer=1+1;</script>",
             tag_formatters: %{script: TagFormatter},
             oxfmt: [semicolons: :as_needed]
           ) == """
           <script>
             const answer = 1 + 1
           </script>
           """
  end

  test "skips runtime script tags" do
    assert TagFormatter.render_tag({"script", %{"runtime" => true}, "const answer=1+1;"}, []) ==
             :skip
  end

  test "skips other tags" do
    assert TagFormatter.render_tag({"style", %{}, ".example{display:block}"}, []) == :skip
  end
end
