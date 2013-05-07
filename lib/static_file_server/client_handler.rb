# encoding: UTF-8

module StaticFileServer
  require 'static_file_server/status'
  require 'static_file_server/request'
  require 'static_file_server/response'
  require 'static_file_server/content'

  #
  # This class is responsible for dealing with the client socket, reading the
  # requests, writing the responses and monitoring connection timeouts.
  #
  # The response is a JSON encoded string with the status code for the
  # request and the response body.
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
        IO.select([@client], nil, nil, 5) or fail TimeoutError

        request  = Request.new(read_request)
        response = Response.from_request(request)

        # Logs the current operation.
        Logger.log(''.tap do |s|
          s << "#{@addrinfo.ip_address} "
          s << "#{request.path} -- "
          s << "#{response.status.code} #{response.status.message}"
        end.send(Utils.color_for_status(response.status)))

        write_response(response)
      end
    ensure
      Logger.log "client disconnected / #{$!.inspect}".yellow
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

    def write_response(response)
      @client.puts(response.to_s)
    end
  end
end
