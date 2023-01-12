defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ],
    image: [ "image/png" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }
  @image %{ accept: %{ image: true } }

  match "/validate/*path", @json do
    Proxy.forward conn, path, "http://validator/validate"
  end

  match "/hello/*path", @json do
    Proxy.forward conn, path, "http://visualiser/hello"
  end

  match "/graph/*path", @image do
    Proxy.forward conn, path, "http://visualiser/graph"
  end

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
