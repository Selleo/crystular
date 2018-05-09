require "kemal"
require "./app/env"
require "./re/**"

get "/" do
  "ok"
end

post "/api/test_regex" do |env|
  params = env.params.body
  parser = Re::Parser.new
  parser.parse(params["regex"], params["options"], params["data"])
end

Kemal.config.port = App::Env.port
Kemal.run
