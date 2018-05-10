require "./match"

class Re::Result
  getter ranges, matches

  def initialize
    @ranges = [] of Array(Int32)
    @matches = [] of Match
  end

  def <<(range : Array(Int32))
    @ranges << range
  end

  def <<(match : Match)
    @matches << match
  end

  def inspect(io : IO)
    to_s(io)
  end

  def to_s(io : IO)
    io << "#<Re::Result ranges: "
    io << ranges.inspect
    io << " matches: "
    io << matches.inspect
    io << ">"
    io
  end

  def to_json(io : IO)
    JSON.build(io) do |json|
      json.object do
        json.field "ranges", @ranges
        json.field "matches", @matches
      end
    end
  end
end
