module Sockettp
  module Client
    class << self
      def request(args)
        socket = TCPSocket.new '0.0.0.0', Sockettp::PORT

        socket.puts args

        response = socket.gets

        socket.close

        response
      end
    end
  end
end
