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
  env.response.content_type = "application/json"
  params = Params.from_json(env.request.body.to_s)
  result = Re::Parser.new.parse(params.regex, params.options, params.data)

rescue ex : Re::Parser::ParseError | Re::Parser::NoMatchError | Re::Parser::InvalidOptionError
  env.response.status_code = 422
  {
    "success": false,
    "error": ex.message.not_nil!
  }.to_json

else
  {
    "success": true,
    "result": result
  }.to_json
end

Kemal.config.port = App::Env.port
Kemal.run
