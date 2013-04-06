module HTTP
  module Client
    autoload :Connection, 'http/client/connection'
    autoload :ConnectionFactory, 'http/client/connection_factory'

    class << self
      #
      # Makes a request to a http server.
      #
      # _uri_ must be a valid HTTP URI (with the http: scheme), host
      # address and file path. Informing the port is optional, since it defaults
      # to 9000 (see HTTP and URI::HTTP).
      #
      def request(uri)
        uri = URI(uri)

        fail URI::BadURIError if !uri.is_a? URI::HTTP

        connection = ConnectionFactory.connect uri.host, uri.port

        begin
          response = connection.request uri.path
          JSON.parse(response)
        rescue
          puts $!
          raise "Couldn't reach #{uri.host}:#{uri.port}"
        end
      end
    end
  end
end
