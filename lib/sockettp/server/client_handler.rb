require 'timeout'

module Sockettp
  module Server
    class ClientHandler
      def initialize(client, addrinfo)
        @client = client
        @addrinfo = addrinfo
      end

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
      def request?
        return !@client.eof?
      end

      def read_request
        @client.gets.chomp
      end

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