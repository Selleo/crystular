require "./../spec_helper"

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

    it "consecutive match" do
      result = parse("(.(o))", "", "awesoooome")

      result.matches.size.should eq 2
      result.matches[0].groups.size.should eq 2
      result.matches[0].groups[0].key.should eq "1"
      result.matches[0].groups[0].text.should eq "so"
      result.matches[0].groups[1].key.should eq "2"
      result.matches[0].groups[1].text.should eq "o"
      result.matches[1].groups.size.should eq 2
      result.matches[1].groups[0].key.should eq "1"
      result.matches[1].groups[0].text.should eq "oo"
      result.matches[1].groups[1].key.should eq "2"
      result.matches[1].groups[1].text.should eq "o"
      result.ranges.should eq [[3, 5], [5, 7]]
    end

    it "any + empty group match" do
      result = parse("(.())", "m", "hello")

      result.matches.size.should eq 5
      result.matches[0].groups.size.should eq 2

      result.matches[0].groups[0].key.should eq "1"
      result.matches[0].groups[0].text.should eq "h"
      result.matches[0].groups[1].key.should eq "2"
      result.matches[0].groups[1].text.should eq ""

      result.matches[1].groups[0].key.should eq "1"
      result.matches[1].groups[0].text.should eq "e"
      result.matches[1].groups[1].key.should eq "2"
      result.matches[1].groups[1].text.should eq ""

      result.matches[2].groups[0].key.should eq "1"
      result.matches[2].groups[0].text.should eq "l"
      result.matches[2].groups[1].key.should eq "2"
      result.matches[2].groups[1].text.should eq ""

      result.matches[3].groups[0].key.should eq "1"
      result.matches[3].groups[0].text.should eq "l"
      result.matches[3].groups[1].key.should eq "2"
      result.matches[3].groups[1].text.should eq ""

      result.matches[4].groups[0].key.should eq "1"
      result.matches[4].groups[0].text.should eq "o"
      result.matches[4].groups[1].key.should eq "2"
      result.matches[4].groups[1].text.should eq ""

      result.ranges.should eq [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]
    end

    it "empty group match + any" do
      result = parse("(.())", "m", "hello")

      result.matches.size.should eq 5
      result.matches[0].groups.size.should eq 2

      result.matches[0].groups[0].key.should eq "1"
      result.matches[0].groups[0].text.should eq "h"
      result.matches[0].groups[1].key.should eq "2"
      result.matches[0].groups[1].text.should eq ""

      result.matches[1].groups[0].key.should eq "1"
      result.matches[1].groups[0].text.should eq "e"
      result.matches[1].groups[1].key.should eq "2"
      result.matches[1].groups[1].text.should eq ""

      result.matches[2].groups[0].key.should eq "1"
      result.matches[2].groups[0].text.should eq "l"
      result.matches[2].groups[1].key.should eq "2"
      result.matches[2].groups[1].text.should eq ""

      result.matches[3].groups[0].key.should eq "1"
      result.matches[3].groups[0].text.should eq "l"
      result.matches[3].groups[1].key.should eq "2"
      result.matches[3].groups[1].text.should eq ""

      result.matches[4].groups[0].key.should eq "1"
      result.matches[4].groups[0].text.should eq "o"
      result.matches[4].groups[1].key.should eq "2"
      result.matches[4].groups[1].text.should eq ""

      result.ranges.should eq [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5]]
    end

    it "group match OR non group match" do
      result = parse("(..)|o", "", "hello")

      result.matches.size.should eq 3
      result.matches[0].groups.size.should eq 1

      result.matches[0].groups[0].key.should eq "1"
      result.matches[0].groups[0].text.should eq "he"

      result.matches[1].groups[0].key.should eq "1"
      result.matches[1].groups[0].text.should eq "ll"

      result.matches[2].groups[0].key.should eq "1"
      result.matches[2].groups[0].text.should eq ""

      result.ranges.should eq [[0, 2], [2, 4], [4, 5]]
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

    it "ends matching at 5000" do
      result = parse("(a)", "", "a" * 5001)

      result.matches.size.should eq 5000
      result.ranges.size.should eq 5000
    end
  end
end
