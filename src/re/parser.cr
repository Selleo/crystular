class Re::Parser
  class ParseError < Exception; end
  class NoMatchError < Exception; end
  class InvalidOptionError < Exception; end

  def parse(regex_str : String, options : String, data : String)
    raise InvalidOptionError.new("Invalid regex option") if options =~ /[^imx]/

    opts = Regex::Options::None
    opts |= Regex::Options::IGNORE_CASE if options.includes?("i")
    opts |= Regex::Options::MULTILINE if options.includes?("m")
    opts |= Regex::Options::EXTENDED if options.includes?("x")

    Result.new.tap do |acc|
      next_match(acc, Regex.new(regex_str, opts), data, 0, true)
    end

  rescue ex : ArgumentError
    raise ParseError.new("Parse error: #{ex.message}")
  end

  private def next_match(acc, regex, data, pos, first)
    name_table = regex.name_table
    result = regex.match(data, pos)
    
    if !result.nil?
      last = -1
      match = Match.new
      
      result.size.times do |i|
        a, b = build_range(result, i)

        if i == 0
          acc << [a, b]
          # for boundries need to skip one forward
          last = (a == b) ? b + 1 : b
        else
          key = name_table.fetch(i, i).to_s
          match << Group.new(key: key, text: data[a...b])
        end
      end

      acc << match if !match.groups.empty?
      next_match(acc, regex, data, last, false)
    else
      if first
        raise NoMatchError.new("No matches found")
      end
    end
  end

  private def build_range(result, i)
    {result.begin(i).not_nil!, result.end(i).not_nil!}
  end
end
