require "kemal"
require "./app/**"

get "/" do
  "ok"
end

post "/api/test_regex" do |env|
  params = env.params.body
  parser = App::RegexParser.new
  parser.parse(params["regex"], params["data"])
end

Kemal.config.port = App::Env.port
Kemal.run
