# encoding: UTF-8

$LOAD_PATH.unshift File.dirname(__FILE__) # For testing

require 'date'
require 'json'
require 'socket'
require 'cape-cod'

#
# The http server module
#
# It listens for new connections at the specified port and dispatches the
# clients to the handlers objects.
#
module StaticFileServer
  require 'static_file_server/core_ext/string'
  require 'static_file_server/version'
  require 'static_file_server/logger'
  require 'static_file_server/client_handler'

  SERVER_NAME = ''.tap do |s|
    s << "Kick Ass Server/#{VERSION}"
    s << ' '
    s << "Ruby/#{RbConfig::CONFIG['ruby_version']}"
  end

  HTTP_VERSION = 'HTTP/1.1'

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
      @handlers.add(Thread.new(socket, addrinfo) do |client, _addrinfo|
        Logger.log 'New client connected'

        ClientHandler.new(client, _addrinfo).loop
      end)
    end
  end
end
