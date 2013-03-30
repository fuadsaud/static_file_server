require 'date'

module Sockettp
  module Server
    autoload :ClientHandler, 'sockettp/server/client_handler'

    class << self
      def start(dir, port = Sockettp::DEFAULT_PORT)
        @@dir = dir
        @@port = port

        puts "Starting Sockettp server..."
        puts "Serving #{@@dir.yellow} on port #{@@port.to_s.green}"

        Socket.tcp_server_loop(@@port) do |socket, client_addrinfo|
          handle socket, client_addrinfo
        end
      end

      def content_for(path)
        path = File.join(@@dir, path)

        return File.read(path) if File.file?(path)
        return Dir[File.join(path, '*')] if File.directory?(path)
      end

      def log(msg)
        puts "#{Thread.current} -- #{DateTime.now.to_s} -- #{msg}"
      end

      private
      def handle(socket, addrinfo)
        Thread.new(socket) do |client|
          log "New client connected"

          ClientHandler.new(client, addrinfo).loop!
        end
      end
    end
  end
end
