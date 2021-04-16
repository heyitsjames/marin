# Marin

## Setup
  * This requires a running version of PostgreSQL on your machine. If you're on a Mac, "PostgresApp" works well.
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start the command line with `iex -S mix`
  * Then, run these two functions: `Marin.sync_races_and_events()` and `Marin.sync_participants_for_new_events()`
  * This will download all the data for all races in the ironman database. Go to the database `marin_dev` to query it.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
