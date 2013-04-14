module HTTP
  module Server

    #
    # Wraps an HTTP status code and message. Objects of this class shouldn't be
    # mannually isntantiated, but recoverd via the [] method, which returns a
    # Status object given a status code.
    #
    class Status

      #
      # Factory method for statuses. Returns the Status object given a status
      # code.
      #
      def self.[](code)
        STATUSES[code]
      end

      attr_reader :code, :message

      private

      #
      # Initializes the object. Shouldn't be mannualy called.
      #
      def initialize(code, message)
        @code = code
        @message = message
      end

      #
      # All valid HTTP statuses.
      #
      STATUSES = {
        100 => new(100, 'Continue'),
        101 => new(101, 'Switching Protocols'),
        200 => new(200, 'OK'),
        201 => new(201, 'Created'),
        202 => new(202, 'Accepted'),
        203 => new(203, 'Non-Authoritative Information'),
        204 => new(204, 'No Content'),
        205 => new(205, 'Reset Content'),
        206 => new(206, 'Partial Content'),
        300 => new(300, 'Multiple Choices'),
        301 => new(301, 'Moved Permanently'),
        302 => new(302, 'Found'),
        303 => new(303, 'See Other'),
        304 => new(304, 'Not Modified'),
        305 => new(305, 'Use Proxy'),
        307 => new(307, 'Temporary Redirect'),
        400 => new(400, 'Bad Request'),
        401 => new(401, 'Unauthorized'),
        402 => new(402, 'Payment Required'),
        403 => new(403, 'Forbidden'),
        404 => new(404, 'Not Found'),
        405 => new(405, 'Method Not Allowed'),
        406 => new(406, 'Not Acceptable'),
        407 => new(407, 'Proxy Authentication Required'),
        408 => new(408, 'Request Timeout'),
        409 => new(409, 'Conflict'),
        410 => new(410, 'Gone'),
        411 => new(411, 'Length Required'),
        412 => new(412, 'Precondition Failed'),
        413 => new(413, 'Request Entity Too Large'),
        414 => new(414, 'Request-URI Too Large'),
        415 => new(415, 'Unsupported Media Type'),
        416 => new(416, 'Request Range Not Satisfiable'),
        417 => new(417, 'Expectation Failed'),
        500 => new(500, 'Internal Server Error'),
        501 => new(501, 'Not Implemented'),
        502 => new(502, 'Bad Gateway'),
        503 => new(503, 'Service Unavailable'),
        504 => new(504, 'Gateway Timeout'),
        505 => new(505, 'HTTP Version Not Supported')
      }
    end
  end
end