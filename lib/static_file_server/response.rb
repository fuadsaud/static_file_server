# encoding: UTF-8

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
    def initialize(status, header,
                    http_version = StaticFileServer::HTTP_VERSION, body = '')

      @http_version = http_version
      @status = status
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
      header = {
        Date:       Time.now.httpdate,
        Server:     StaticFileServer::SERVER_NAME,
      }

      if request.header['If-Modified-Since']
        if_modified_since = Time.httpdate(request.header['If-Modified-Since'])
      end

      content = Content.new(request.path, if_modified_since)

      connection = request.http_version == 'HTTP/1.1' ? 'Keep-Alive' : 'Close'

      header.merge!({
        Etag:       content.etag,
        Connection: connection,
        :'Last-Modified'  => content.modification_time.httpdate,
        :'Content-Length' => content.length,
      })

      new(Status.new(200, 'OK') , header, request.http_version, content.data)

    rescue Status => e
      new(e, header, request.http_version)
    end
  end
end
