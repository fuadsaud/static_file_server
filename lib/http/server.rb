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

      # Returns the file content for the given path
      #
      # If the path represents an ordinary file, the method just reads it's
      # content. In case it's a directory, it returns an array containing the
      # file entries in that dir. Retrurns nil in case the file doesn't exists.
      #
      def content_for(path)
        path = File.join(@@dir, path)

        File.file?(path)      and return File.read(path)
        File.directory?(path) and return Dir.glob(File.join(path, '*'))
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
