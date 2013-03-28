module Sockettp
  module Client
    class << self
      def request(args)
        uri = URI(args)

        fail URI::BadURIError if !uri.is_a? URI::Sockettp

        socket = TCPSocket.new uri.host, uri.port

        socket.puts uri.path

        response = socket.gets

        socket.close

        JSON.parse(response)
      end
    end
  end
end
