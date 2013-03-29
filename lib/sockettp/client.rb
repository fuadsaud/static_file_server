module Sockettp
  module Client
    autoload :ConnectionManager, 'sockettp/client/connection_manager'

    class << self
      def request(args)
        uri = URI(args)

        fail URI::BadURIError if !uri.is_a? URI::Sockettp

        socket = ConnectionManager.connect uri.host, uri.port

        socket.puts uri.path

        response = socket.gets

        JSON.parse(response)
      end
    end
  end
end
