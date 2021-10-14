defmodule ConduitElixir.Repo do
  use Ecto.Repo,
    otp_app: :conduit_elixir,
    adapter: Ecto.Adapters.Postgres
end
