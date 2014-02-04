require 'socket'
BUFSIZE = 4096

class Connection
  def initialize(host, port)
    @socket = TCPSocket.open(host, port)
  end

  def send(packet)
    return @socket.puts(packet)
  end

  def recv()
    return @socket.gets()
  end
end

