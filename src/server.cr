require "kemal"
require "./app/env"
require "./re/**"

struct Params
  JSON.mapping({
    regex: String,
    options: String,
    data: String
  })
end

post "/api/test_regex" do |env|
  params = Params.from_json(env.request.body.to_s)
  result = Re::Parser.new.parse(params.regex, params.options, params.data)
  env.response.content_type = "application/json"
  result.to_json
end

Kemal.config.port = App::Env.port
Kemal.run
