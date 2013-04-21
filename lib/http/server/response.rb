# encoding: UTF-8

require 'http/server/status'
require 'http/server/utils'

module HTTP
  module Server

    #
    # This class represents an HTTP response, wrapping the HTTP version, status,
    # header and body.
    #
    class Response

      include Utils

      attr_accessor :version, :status, :header

      #
      # Initializes the object with the given parameters.
      #
      def initialize(http_version, status, header, body)
        @http_version = Server::HTTP_VERSION
        @status = Status[status]
        @header = header
        @body = body
      end

      #
      # Dumps the object to a string in a valid HTTP header format.
      #
      def to_s
        string = "HTTP/#{@http_version} #{@status.code} #{@status.message}#{CRLF}"

        @header.each do |key, value|
          string << "#{key}: #{value}#{CRLF}"
        end

        string << "#{CRLF}#{@body}"
      end
    end
  end
end
