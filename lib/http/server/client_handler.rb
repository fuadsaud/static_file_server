module HTTP
  module Server

    autoload :Request,  'http/server/request'
    autoload :Response, 'http/server/response'
    autoload :Content,  'http/server/content'

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

          request  = Request.new(read_request)
          content  = Content.new(request.path)
          response = Response.new(Server::HTTP_VERSION,
                                  content.data ? 200 : 404,
                                  request.header.merge({
            Connection: 'Keep-Alive',
            Server:      'Kick Ass HTTP Server',
            Date:       DateTime.now.httpdate,
            :'Content-Length' => content.length
          }), content.data)

          # Logs the current operation.
          Logger.log(''.tap {|s|
            s << "#{@addrinfo.ip_address} "
            s << "#{request.path} --"
            s << "#{response.status.code} #{response.status.message}"
          }.send(response.status.code == 200 ? :green : :red))

          @client.puts(response.to_s)
        end
      ensure
        Logger.log "client disconnected / #{$!}".yellow
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