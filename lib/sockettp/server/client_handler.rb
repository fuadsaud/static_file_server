require 'timeout'

module Sockettp
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
      def loop!
        loop do
          Timeout.timeout(5) { request? }

          input = read_request

          body = Server.content_for(input)

          response = build_response_for(body)

          Server.log "#{@addrinfo.ip_address} #{input} -- #{response[:status]} #{Sockettp::STATUSES[response[:status]]}".send(response[:status] == 200 ? :green : :red)

          @client.puts(response.to_json)
        end
      ensure
        puts '-' * 75 + " client disconnected #{$!.message}"
        @client.close
      end

      private
      #
      # Check if there's a pending request from the client
      #
      def request?
        return !@client.eof?
      end

      #
      # Read the request string from the client
      #
      def read_request
        @client.gets.chomp
      end

      #
      # Builds a response hash given the response body
      #
      def build_response_for(body)
        if body
          { status: 200, body: body }
        else
          { status: 404, body: Sockettp::STATUSES[404] }
        end
      end
    end
  end
end