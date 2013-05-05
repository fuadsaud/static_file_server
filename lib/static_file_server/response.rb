# encoding: UTF-8

require 'static_file_server/status'
require 'static_file_server/utils'

module StaticFileServer

  #
  # This class represents an HTTP response, wrapping the HTTP version,
  # status, header and body.
  #
  class Response

    include Utils

    attr_accessor :version, :status, :header

    #
    # Initializes the object with the given parameters.
    #
    def initialize(http_version = StaticFileServer::HTTP_VERSION,
                   status, header, body)
      @http_version = http_version
      @status = Status[status]
      @header = header
      @body = body
    end

    #
    # Dumps the object to a string in a valid HTTP header format.
    #
    def to_s
      string = ''.tap do |s|
        s << @http_version << ' '
        s << "#{@status.code} #{@status.message}"
        s << CRLF
      end

      @header.each do |key, value|
        string << "#{key}: #{value}#{CRLF}"
      end

      string << "#{CRLF}#{@body}"
    end

    def self.from_request(request)
      content = Content.new(request.path)

      status = content.data ? 200 : 404

      connection = request.http_version == 'HTTP/1.1' ? 'Keep-Alive' : 'Close'

      Response.new(request.http_version, status, request.header.merge({
        Connection: connection,
        Server:     StaticFileServer::SERVER_NAME,
        Date:       DateTime.now.httpdate,
        :'Content-Length' => content.length
      }), content.data)
    end
  end
end
