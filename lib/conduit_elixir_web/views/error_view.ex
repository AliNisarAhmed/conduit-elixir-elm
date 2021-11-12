defmodule ConduitElixirWeb.ErrorView do
  use ConduitElixirWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.json", _assigns) do
    %{errors: %{body: "Internal Server Error"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{body: "Not found"}}
  end

  def render("401.json", _assigns) do 
    %{errors: %{body: "Unauthorized"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{body: Phoenix.Controller.status_message_from_template(template)}}
  end
end
