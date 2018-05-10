require "./group"

struct Re::Match
  getter groups

  def initialize
    @groups = [] of Group
  end

  def <<(group)
    @groups << group
  end

  def inspect(io : IO)
    to_s(io)
  end

  def to_s(io : IO)
    io << "#<Re::Match groups: ["
    io << groups.map do |group|
      group.inspect
    end.join(", ")
    io << "]>"
    io
  end

  def to_json(json : JSON::Builder)
    json.array do
      @groups.each do |group|
        json.object do
          json.field "key", group.key
          json.field "text", group.text
        end
      end
    end
  end
end
