require 'date'

module Sockettp
  class Server
    def initialize(dir, port = Sockettp::DEFAULT_PORT)
      @dir = dir
      @port = port
    end

    def start
      puts "Starting Sockettp server"

      socket = TCPServer.new @port

      puts "Serving #{@dir.yellow} on port #{socket.addr[1].to_s.green}"

      loop do
        client = socket.accept

        handle client
      end
    end

    private
    def handle(client)
      Thread.new do
        loop do
          if client.eof?
            # puts "#{'-' * 100} end connection"
            Thread.exit
          end

          input = client.gets.chomp

          print "#{DateTime.now.to_s} -- #{client.addr.last}: #{input}"

          body = content_for(input)

          response = {}

          if body
            response.merge!({
              status: 200,
              body: body
            })
          else
            response.merge!({
              status: 404,
              body: Sockettp::STATUSES[404]
            })
          end

          puts " -- #{response[:status]} #{Sockettp::STATUSES[response[:status]]}".send(response[:status] == 200 ? :green : :red)

          client.puts(response.to_json)
        end
      end
    end

    def content_for(path)
      path = File.join(@dir, path)

      return File.read(path) if File.file?(path)
      return Dir["#{path}/*"] if File.directory?(path)
    end
  end
end
