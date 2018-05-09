require "../../spec_helper"


def parse(regex_str, options, data)
  Re::Parser.new.parse(regex_str, options, data)
end

describe Re::Parser do
  describe "#parse" do
    it "no group matches" do
      result = parse("o", "", "hello\nworld")

      result.matches.size.should eq 0
      result.ranges.should eq [[4, 5], [7, 8]]
    end

    it "index group match" do
      result = parse("(o)", "", "hello\nworld")

      result.matches.size.should eq 2
      result.matches[0].groups.size.should eq 1
      result.matches[0].groups[0].key.should eq "1"
      result.matches[0].groups[0].text.should eq "o"
      result.matches[1].groups.size.should eq 1
      result.matches[1].groups[0].key.should eq "1"
      result.matches[1].groups[0].text.should eq "o"
      result.ranges.should eq [[4, 5], [7, 8]]
    end

    it "named group match" do
      result = parse("(?<key>.(o))", "", "hello world")

      result.matches.size.should eq 2
      result.matches[0].groups.size.should eq 2
      result.matches[0].groups[0].key.should eq "key"
      result.matches[0].groups[0].text.should eq "lo"
      result.matches[0].groups[1].key.should eq "2"
      result.matches[0].groups[1].text.should eq "o"
      result.matches[1].groups.size.should eq 2
      result.matches[1].groups[0].key.should eq "key"
      result.matches[1].groups[0].text.should eq "wo"
      result.matches[1].groups[1].key.should eq "2"
      result.matches[1].groups[1].text.should eq "o"
      result.ranges.should eq [[3, 5], [6, 8]]
    end

    it "case sensitive match" do
      expect_raises(Re::Parser::NoMatchError, "No matches") do
        parse("ll", "", "HELLO")
      end
    end

    it "case insensitive match" do
      result = parse("ll", "i", "HELLO")

      result.matches.size.should eq 0
      result.ranges.should eq [[2, 4]]
    end

    it "no multiline match" do
      expect_raises(Re::Parser::NoMatchError, "No matches") do
        parse("t.", "", "bat\nman")
      end
    end

    it "multiline match" do
      result = parse("t.", "m", "bat\nman")

      result.matches.size.should eq 0
      result.ranges.should eq [[2, 4]]
    end

    it "no extended match" do
      regex = <<-REGEX
        x          # this is x
        -          # one dash
        [a-z]{3}   # 3 letters
      REGEX

      expect_raises(Re::Parser::NoMatchError, "No matches") do
        parse(regex, "", "x-men")
      end
    end

    it "all combined: case insensitive / extended / multiline match" do
      regex = <<-REGEX
        x          # this is x
        .          # anything
        -          # one dash
        .          # anything
        [a-z]{3}   # 3 letters
      REGEX

      result = parse(regex, "ixm", "X\n-\nMEN")
    end

    it "word boundry match" do
      result = parse("\\b", "", "batman")

      result.matches.size.should eq 0
      result.ranges.should eq [[0, 0], [6, 6]]
    end
  end
end
