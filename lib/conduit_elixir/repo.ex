defmodule ConduitElixir.Repo do
  use Ecto.Repo,
    otp_app: :conduit_elixir,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
