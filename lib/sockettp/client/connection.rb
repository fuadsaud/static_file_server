module Sockettp
  module Client
    class Connection
      def initialize(host, port)
        @host = host
        @port = port
        @socket = Connection.build_socket(@host, @port)
      end

      def request(args)
        @socket.puts args
        @socket.gets or fail
      rescue
        @socket = Connection.build_socket(@host, @port)
        retry
      end

      private
      def self.build_socket(host, port)
        TCPSocket.new(host, port)
      end
    end
  end
end
