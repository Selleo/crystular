require "./../../spec_helper"

def test_regex(regex : String?, options : String?, data : String?)
  body = JSON.build do |json|
    json.object do
      json.field "regex", regex if !regex.nil?
      json.field "options", options if !options.nil?
      json.field "data", data if !data.nil?
    end
  end

  response = post "/api/test_regex", headers: json_headers, body: body
  JSON.parse(response.body).as_h
end

describe "/api/test_regex" do
  it "returns valid match" do
    json = test_regex("he(?<double>ll)o", "", "hello world")

    json.has_key?("ranges").should eq true
    json.has_key?("matches").should eq true
    json["ranges"].should eq [[0, 5]]
    json["matches"].should eq [
      [
        {
          "key" => "double",
          "text" => "ll"
        }
      ]
    ]
  end
end
