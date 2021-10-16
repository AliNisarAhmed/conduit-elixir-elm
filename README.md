# ConduitElixir

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Commands 

Start iex in mix project
    - `iex -S mix`

Install dependencies
    - `mix deps.get`

Run server
    - `mix phx.server`

Check all routes on the application 
    - `mix phx.routes`

Create Database (Change settings in `config/dev.exs` file before doing this)
    - `mix ecto.create`

Generate Migration file 
    - `mix ecto.gen.migration create_users`

Run a Migration 
    - `mix ecto.migrate`

Generate Context
    - `mix phx.gen.context`
    - Example: 
        - `mix phx.gen.context Multimedia Category categories name:string`

Generate Schema 
    - `mix phx.gen.schema`
    - Example
        - `mix phx.gen.schema Multimedia.Category categories name:string`

Rollback a migration
    - `mix ecto.rollback`

Generate scaffold in phoenix
    - `mix phx.gen.html` or `mix phx.gen.json`
    - Example: 
        - `mix phx.gen.html Multimedia Video videos user_id:references:users url:string title:string description:text`

