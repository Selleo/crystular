struct Re::Group
  getter key, text

  def initialize(@key : String, @text : String)
  end

  def inspect(io : IO)
    to_s(io)
  end

  def to_s(io : IO)
    io << "#<Re::Group key: "
    io << key.inspect
    io << " text: "
    io << text.inspect
    io
  end
end
