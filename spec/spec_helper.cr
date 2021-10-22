ENV["KEMAL_ENV"] = "test"
require "spec"
require "spec-kemal"
require "../src/main"

def json_headers
  HTTP::Headers{
    "Content-type" => "application/json",
  }
end
