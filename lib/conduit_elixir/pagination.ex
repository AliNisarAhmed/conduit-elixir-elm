defmodule ConduitElixir.Pagination do 

  @default_page_params %{
    page: 1, page_size: 10
  }

  def get_page_params(params) do
    page = Map.get(params, "page", @default_page_params.page)
    page_size = Map.get(params, "page_size", @default_page_params.page_size)

    %{page: page, page_size: page_size}
  end

  def default_page_params(), do: @default_page_params
end
