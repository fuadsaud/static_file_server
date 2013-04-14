require 'http/server/request'
require 'http/server/response'

module HTTP
  module Server

    #
    # This class is responsible for dealing with the client socket, reading the
    # requests, writing the responses and monitoring connection timeouts.
    #
    # The response is a JSON encoded string with the status code for the request
    # and the response body.
    #
    class ClientHandler

      #
      # Receives the client socket and it's addrinfo object
      #
      def initialize(client, addrinfo)
        @client = client
        @addrinfo = addrinfo
      end

      #
      # Loops infinely checking if the client is still active (has made a
      # request), fetches the response content and writes it to the client
      # stream.
      #
      def loop
        Kernel.loop do
          IO.select([@client], nil, nil, 5) or fail 'timeout'

          request = Request.new(read_request)

          body = Server.content_for(request.path)

          response = Response.new(Server::HTTP_VERSION, body ? 200 : 404, {
            Connection: 'Keep-Alive',
            Sever:      'fuad suad server',
            Date:       DateTime.now
          }, body)

          status = response.status

          Server.log <<-LOG.send(status.code == 200 ? :green : :red)
#{@addrinfo.ip_address} #{request.path} -- #{status.code} #{status.message}
LOG

          @client.puts(response.to_s)
        end
      ensure
        puts '-' * 75 + " client disconnected / #{$!}"
        @client.close
      end

      private

      #
      # Read the request string from the client
      #
      def read_request
        request = ''

        Kernel.loop do
          line = @client.gets
          break if line.chomp.empty?
          request << line
        end

        request
      rescue
        raise 'client closed connection'
      end
    end
  end
end