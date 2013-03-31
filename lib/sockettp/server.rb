require 'date'

module Sockettp
  #
  # The sockettp server module
  #
  # It listens for new connections at the specified port and dispatches the
  # clients to the handlers objects.
  #
  module Server
    autoload :ClientHandler, 'sockettp/server/client_handler'

    class << self
      def start(dir, port = Sockettp::DEFAULT_PORT)
        fail "#{dir} doesn't exists or is't a directory" if !File.directory?(dir)

        @@dir = dir
        @@port = port

        puts "Starting Sockettp server..."
        puts "Serving #{@@dir.yellow} on port #{@@port.to_s.green}"

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

        return File.read(path) if File.file?(path)
        return Dir[File.join(path, '*')] if File.directory?(path)
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
          log "New client connected"

          ClientHandler.new(client, addrinfo).loop!
        end
      end
    end
  end
end
