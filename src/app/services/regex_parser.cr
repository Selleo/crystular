class App::RegexParser
  class ParseError < Exception
  end

  class Result
  end

  def parse(regex : String, data : String) : Result
    Result.new
  end
end
