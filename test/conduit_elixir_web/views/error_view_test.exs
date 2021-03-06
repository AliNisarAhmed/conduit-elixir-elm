defmodule ConduitElixirWeb.ErrorViewTest do
  use ConduitElixirWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ConduitElixirWeb.ErrorView, "404.json", []) == %{errors: %{body: "Not found"}}
  end

  test "renders 500.json" do
    assert render(ConduitElixirWeb.ErrorView, "500.json", []) ==
             %{errors: %{body: "Internal Server Error"}}
  end
end
