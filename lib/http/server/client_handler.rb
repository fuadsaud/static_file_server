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
        loop do
          IO.select([@client], nil, nil, 2) or fail 'timeout'

          input = read_request

          body = Server.content_for(input)

          response = build_response_for(body)

          Server.log "#{@addrinfo.ip_address} #{input} -- #{response[:status]} #{HTTP::STATUSES[response[:status]]}".send(response[:status] == 200 ? :green : :red)

          @client.puts(response.to_json)
        end
      ensure
        puts '-' * 75 + " client disconnected / #{$!.message}"
        @client.close
      end

      private

      #
      # Read the request string from the client
      #
      def read_request
        @client.gets.chomp
      rescue
        raise 'client closed connection'
      end

      #
      # Builds a response hash given the response body
      #
      def build_response_for(body)
        if body
          { status: 200, body: body }
        else
          { status: 404, body: HTTP::STATUSES[404] }
        end
      end
    end
  end
end