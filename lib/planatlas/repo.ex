defmodule Planatlas.Repo do
  use Ecto.Repo,
    otp_app: :planatlas,
    adapter: Ecto.Adapters.Postgres
end
