# Lessthanseventy

To start your Phoenix server:


  * Run `asdf install` to install elixir and erlang versions
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/xml_upload`](http://localhost:4000/xml_upload) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


#API
You can use the following command to create an xml upload resource:

`╰─λ curl -X POST -H "Content-Type: text/xml" -d \
@/home/andrew/projects/lessthanseventy/priv/static/uploads/live_view_upload-1724864097-698321950597-2 \
http://localhost:4000/api/xml_uploads`

Use the following to delete a resource:

`╰─λ curl -X DELETE http://localhost:4000/api/xml_uploads/5 -H "Content-Type: \
application/json" -d '{"id":"5"}'`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
