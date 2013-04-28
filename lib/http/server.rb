# encoding: UTF-8

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

    require 'http/server/client_handler'
    require 'http/server/logger'

    class << self

      # Attribute readers for dir and port.
      attr_reader :dir
      attr_reader :port

      @status = :stopped

      #
      # Starts the server in the given port, serving the given directory. It
      # loops infinetly and is only stopped when the process receives a signal.
      #
      def start(dir, port = URI::HTTP::DEFAULT_PORT)
        fail "Cannot access #{dir} dir" unless File.directory?(dir)

        @dir = dir
        @port = port
        @handlers = ThreadGroup.new

        Logger.log 'Starting HTTP server...'
        Logger.log "Serving #{@dir.yellow} on port #{@port.to_s.green}"

        @status = :running

        @loop_thread = Thread.new do
          Socket.tcp_server_loop(@port) do |socket, client_addrinfo|
            handle socket, client_addrinfo
          end
        end

        @loop_thread.join
      end

      def stop
        @handlers.list.each(&:exit)
        @loop_thread.exit
        @loop_thread = nil
        @status = :stopped
      end

      private

      #
      # Dispatches the client socket to a ClientHandler.
      #
      def handle(socket, addrinfo)
        @handlers.add(Thread.new(socket) do |client|
          Logger.log 'New client connected'

          ClientHandler.new(client, addrinfo).loop
        end)
      end
    end
  end
end
