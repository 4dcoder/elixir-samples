# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :getting_started_elixir,
  ecto_repos: [GettingStartedElixir.Repo]

# Configures the endpoint
config :getting_started_elixir, GettingStartedElixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9/WsVfli//XqrDVN9Y3F2PvdNqEPk4UAddz7EcQkhp3gr365DWMz6zCZSkWGMxec",
  render_errors: [view: GettingStartedElixirWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GettingStartedElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :goth,
  json: {:system, "GCP_CREDENTIALS"}

# If using Datastore, use this line
config :getting_started_elixir, :storage_engine, GettingStartedElixir.DatastoreRepo

# If using Postgres or MySQL, use this line
# config :getting_started_elixir, :storage_engine, GettingStartedElixir.Repo

# If using Postgres, set configuration variables here
# config :getting_started_elixir, GettingStartedElixir.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   database: "YOUR_DATABASE_NAME",
#   username: "YOUR_CLOUDSQL_USER",
#   password: "YOUR_CLOUDSQL_PASSWORD",
#   socket: "/cloudsql/INSTANCE_CONNECTION_NAME",
#   pool_size: 10

# If using MySQL, set configuration variables here
# config :getting_started_elixir, GettingStartedElixir.Repo,
#   adapter: Ecto.Adapters.MySQL,
#   database: "YOUR_DATABASE_NAME",
#   username: "YOUR_CLOUDSQL_USER",
#   password: "YOUR_CLOUDSQL_PASSWORD",
#   socket: "/cloudsql/INSTANCE_CONNECTION_NAME",
#   pool_size: 10
