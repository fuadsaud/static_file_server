module HTTP
  module Client
    #
    # This class wraps a socket connection, providing protocol related
    # calls.

    # It is also acts as a factory for itself's instances. Connections are
    # stored in the _connections_ hash, indexed by a host-port hash.
    #
    class Connection

      class << self
        attr_accessor :connections
      end

      self.connections = []

      #
      # This method looks up the _connections_ array checking if there is
      # already an open connections with the given host/port server. In case
      # if there isn't one, it creates a Connection object, stores it in the
      # array and returns it. In case there is an existing connection, the
      # respective Connection object is returned.
      #
      def self.connect(host, port)
        key = "#{host}:#{port}".to_sym

        self.connections[key] || self.connections[key] = new(host, port)
      end

      def initialize(host, port)
        @host = host
        @port = port
        @socket = Connection.build_socket(@host, @port)
      end

      def request(args)
        @socket.puts args
        @socket.gets or fail
      rescue
        @socket = Connection.build_socket(@host, @port)
        retry
      end

      private

      def self.build_socket(host, port)
        TCPSocket.new(host, port)
      end
    end
  end
end
