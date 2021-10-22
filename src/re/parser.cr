class Re::Parser
  class ParseError < Exception; end

  class NoMatchError < Exception; end

  class InvalidOptionError < Exception; end

  RECURSION_LIMIT = 5000

  def parse(regex_str : String, options : String, data : String)
    raise InvalidOptionError.new("Invalid regex option") if options =~ /[^imx]/

    opts = Regex::Options::None
    opts |= Regex::Options::IGNORE_CASE if options.includes?("i")
    opts |= Regex::Options::MULTILINE if options.includes?("m")
    opts |= Regex::Options::EXTENDED if options.includes?("x")

    Result.new.tap do |acc|
      next_match(acc, Regex.new(regex_str, opts), data, 0, true, RECURSION_LIMIT)
    end
  rescue ex : ArgumentError
    raise ParseError.new("Parse error: #{ex.message}")
  end

  private def next_match(acc, regex, data, pos, first, n)
    name_table = regex.name_table
    result = regex.match(data, pos)

    if !result.nil?
      last = -1
      match = Match.new

      result.size.times do |i|
        valid, a, b = build_range(result, i)

        if i == 0
          acc << [a, b]
          # for boundries need to skip one forward
          last = (a == b) ? b + 1 : b
        else
          key = name_table.fetch(i, i).to_s
          match << Group.new(key: key, text: valid ? data[a...b] : "")
        end
      end

      acc << match if !match.groups.empty?
      next_match(acc, regex, data, last, false, n - 1) if n > 1
    else
      if first
        raise NoMatchError.new("No matches found")
      end
    end
  end

  private def build_range(result, i)
    # NOTE:
    # Happened after upgrade Crystal 0.36.1 -> 1.2.1
    # Need to check bytes first,
    # otherwise calling .begin(), .end()
    # will raise an error because it forces .not_nil!

    a = result.byte_begin(i)
    b = result.byte_end(i)

    if a != -1 && b != -1
      a = result.begin(i)
      b = result.end(i)

      {true, a, b}
    else
      {false, -1, -1}
    end
  end
end
