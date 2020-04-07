# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :planatlas,
  ecto_repos: [Planatlas.Repo]

# Configures the endpoint
config :planatlas, PlanatlasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PVqeyCd7tNhgnWiJ40keJHHZuo+mNCFUqdrrtiM40PWVouX+nt4XZGqjC3OdvemI",
  render_errors: [view: PlanatlasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Planatlas.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "PDNhnGHG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
