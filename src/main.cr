require "kemal"
require "./app/env"
require "./re/**"

get "/" do
  render "src/views/index.ecr"
end

post "/api/test_regex" do |env|
  params = env.params.json
  result = Re::Parser.new.parse(
    params["regex"].as(String),
    params["options"].as(String),
    params["text"].as(String)
  )
  env.response.content_type = "application/json"
    
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
