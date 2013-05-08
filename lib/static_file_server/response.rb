# encoding: UTF-8

require 'static_file_server/utils'

module StaticFileServer

  #
  # This class represents an HTTP response, wrapping the HTTP version,
  # status, header and body. It is not responsible for any domain logic,
  # only for carrying data around a generating it's string represention.
  #
  class Response

    include Utils

    attr_accessor :version, :status, :header

    #
    # Initializes the object with the given parameters.
    #
    def initialize(status, header, http_version, body = '')

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

    def self.build(status = Status[200],
                   header = {},
                   http_version = StaticFileServer::HTTP_VERSION,
                   content)
      header = {
        Date:       Time.now.httpdate,
        Server:     StaticFileServer::SERVER_NAME,
        Connection: http_version == 'HTTP/1.1' ? 'Keep-Alive' : 'Close',
        :'Last-Modified'  => content.modification_time.httpdate,
        :'Content-Length' => content.length,
        :'Content-Type' => content.type,
      }.merge(header)

      new(status, header, http_version, content.data)
    end

    #
    # Factory method for creating an HTTP response from an HTTP request.
    # It tries to create a Content object from the +request+ path
    # possible
    #
    def self.from_request(request)
      if request.header['If-Modified-Since']
        if_modified_since = Time.httpdate(request.header['If-Modified-Since'])
      end

      content = Content.from_filesystem(request.path, if_modified_since)

      header = {}.tap do |h|
        h[:Connection] = 'close' if request.header['Connection'] == 'close'
      end

      build(Status[200], header, request.http_version, content)

    rescue Status => e
      build(e, {}, request.http_version, Content.new("#{e.code} #{e.message}"))
    end
  end
end
