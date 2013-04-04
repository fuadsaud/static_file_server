module Sockettp
  module Client
    class Connection
      def initialize(host, port)
        @host = host
        @port = port
        @socket = TCPSocket.new @host, @port
      end

      def request(args)
        @socket.puts args
        @socket.gets || fail
      rescue
        @socket = TCPSocket.new @host, @port
        retry
      end
    end
  end
end
