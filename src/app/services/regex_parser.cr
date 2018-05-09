class App::RegexParser
  class ParseError < Exception
  end

  class NoMatchError < Exception
  end

  struct Result
    getter match
  end

  struct MatchData
    getter data, range

    def initialize(@data : String, range : Range)
    end
  end

  def parse(regex : String, data : String)
    # Regex::Options::IGNORE_CASE | Regex::Options::MULTILINE | Regex::Options::EXTENDED
    log "\n"
    re = Regex.new(regex)
    result = re.match(data)
    log data.inspect
    if !result.nil?
      (1..result.size).each_with_index do |mi, i|
        a, b = result.begin(i).not_nil!.to_i, result.end(i).not_nil!.to_i
        log "Match #{i}: #{a}..#{b} | #{data[a..b]}"
      end

      log result.inspect
    else
      raise NoMatchError.new("No matches")
    end
  end
end
