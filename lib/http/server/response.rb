require 'http/server/status'
require 'http/server/utils'

module HTTP
  module Server
    class Response

      include Utils

      attr_accessor :version, :status, :headers

      def initialize(version, status, headers, body)
        @version = '1.1'
        @status = Status[status]
        @headers = headers
        @body = body
      end

      def to_s
        response = "HTTP/#{@version} #{@status.code} #{@status.message}#{CRLF}"

        @headers.each do |key, value|
          response << "#{key}: #{value}#{CRLF}"
        end

        response << "#{CRLF}#{@body}"

        response
      end
    end
  end
end
