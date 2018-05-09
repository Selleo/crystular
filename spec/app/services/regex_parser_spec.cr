require "../../spec_helper"


def parse(regex_str, data)
  App::RegexParser.new.parse(regex_str, data)
end

describe App::RegexParser do
  describe "#parse(String, String):Result" do
    # it do
    #   parse("o", "hello\nworld")
    # end

    # it do
    #   parse("(o)", "hello\nworld")
    # end

    it do
      parse("(.(o))", "hello\nworld")
    end

    # it do
    #   parse("(?:.(o))", "hello\nworld")
    # end
  end
end
