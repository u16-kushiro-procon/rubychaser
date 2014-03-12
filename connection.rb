require 'socket'

class Connection
  def initialize(host, port)
    @socket = TCPSocket.open(host, port)
  end

  def send(packet)
    return @socket.puts(packet)
  end

  def recv
    return @socket.gets
  end

  def close
    @socket.close
  end
end

