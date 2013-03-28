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
            puts "#{'-' * 100} end connection"
            Thread.exit
          end

          input = client.gets.chomp

          puts "REQUEST from #{client.addr.last}: #{input}"

          response = File.read(File.join(@dir, input))

          client.puts(status: 'OK', response: response.to_json)
        end
      end
    end
  end
end
