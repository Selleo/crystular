require "./../../spec_helper"

def test_regex(regex : String?, options : String?, data : String?)
  body = JSON.build do |json|
    json.object do
      json.field "regex", regex if !regex.nil?
      json.field "options", options if !options.nil?
      json.field "text", data if !data.nil?
    end
  end

  post "/api/test_regex", headers: json_headers, body: body
end

def parse_body(response)
  JSON.parse(response.body).as_h
end

describe "/api/test_regex" do
  it "returns valid match" do
    response = test_regex("he(?<double>ll)o", "", "hello world")

    response.status_code.should eq 200
    json = parse_body(response)
    json["success"].should eq true
    json["result"].should eq({
      "ranges" => [[0, 5]],
      "matches" => [
        [
          {
            "key" => "double",
            "text" => "ll"
          }
        ]
      ]
    })
  end

  describe "errors" do
    it "returns invalid option" do
      response = test_regex("o", "z", "hello world")
      
      response.status_code.should eq 422
      json = parse_body(response)
      json["success"].should eq false
      json["error"].should eq "Invalid regex option"
    end

    it "returns no matches" do
      response = test_regex("[abc]", "", "hello")

      response.status_code.should eq 422
      json = parse_body(response)
      json["success"].should eq false
      json["error"].should eq "No matches found"
    end

    it "returns parse error" do
      response = test_regex("())", "", "hello")
      
      response.status_code.should eq 422
      json = parse_body(response)
      json["success"].should eq false
      json["error"].should eq "Parse error: unmatched parentheses at 2"
    end
  end
end
