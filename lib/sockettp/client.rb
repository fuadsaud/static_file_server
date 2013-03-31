module Sockettp
  module Client
    autoload :ConnectionManager, 'sockettp/client/connection_manager'

    class << self
      #
      # Makes a request to a sockettp server.
      #
      # _uri_ must be a valid Sockettp URI (with the sockettp: scheme), host
      # address and file path. Informing the port is optional, since it defaults
      # to 9000 (see Sockettp and URI::Sockettp).
      #
      def request(uri)
        uri = URI(uri)

        fail URI::BadURIError if !uri.is_a? URI::Sockettp

        socket = ConnectionManager.connect uri.host, uri.port

        socket.puts uri.path

        response = socket.gets

        JSON.parse(response)
      end
    end
  end
end
