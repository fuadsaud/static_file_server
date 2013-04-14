require 'http/server/status'
require 'http/server/utils'

module HTTP
  module Server
    class Response

      include Utils

      attr_accessor :version, :status, :header

      def initialize(http_version, status, header, body)
        @http_version = Server::HTTP_VERSION
        @status = Status[status]
        @header = header
        @body = body
      end

      def to_s
        response = "HTTP/#{@http_version} #{@status.code} #{@status.message}#{CRLF}"

        @header.each do |key, value|
          response << "#{key}: #{value}#{CRLF}"
        end

        response << "#{CRLF}#{@body}"

        response
      end
    end
  end
end
