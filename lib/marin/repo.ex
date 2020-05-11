defmodule Marin.Repo do
  use Ecto.Repo,
    otp_app: :marin,
    adapter: Ecto.Adapters.Postgres
end
