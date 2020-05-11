# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :marin,
  ecto_repos: [Marin.Repo]

config :verk_web, VerkWeb.Endpoint, url: [path: "/jobs"]

config :logger,
  level: :info

# Configures the endpoint
config :marin, MarinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8PqD/P9Kse9KOXaaBXNwDZQUqpNVaJVnwV4uSuFibfInDyf0HoVjY0QkJ5u5dgmJ",
  render_errors: [view: MarinWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Marin.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "CvnffPlt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
