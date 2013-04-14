require 'date'

module HTTP
  #
  # The http server module
  #
  # It listens for new connections at the specified port and dispatches the
  # clients to the handlers objects.
  #
  module Server
    HTTP_VERSION = '1.1'

    autoload :ClientHandler, 'http/server/client_handler'

    class << self
      def dir;  @@dir  end
      def port; @@port end

      def start(dir, port = URI::HTTP::DEFAULT_PORT)
        fail "Cannot access #{dir} dir" unless File.directory?(dir)

        @@dir = dir
        @@port = port

        log "Starting HTTP server..."
        log "Serving #{@@dir.yellow} on port #{@@port.to_s.green}"

        Socket.tcp_server_loop(@@port) do |socket, client_addrinfo|
          handle socket, client_addrinfo
        end
      end

      #
      # Logs a message to STDOUT, printing the current thread's id, the current
      # time and the given message.
      #
      def log(msg)
        puts "#{Thread.current} -- #{DateTime.now.to_s} -- #{msg}"
      end

      private

      #
      # Dispatches the client socket to a ClientHandler
      #
      def handle(socket, addrinfo)
        Thread.new(socket) do |client|
          log 'New client connected'

          ClientHandler.new(client, addrinfo).loop
        end
      end
    end
  end
end
