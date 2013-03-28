module Sockettp
  class Server
    def initialize(dir)
      @dir = dir
    end

    def start
      puts "Starting Sockettp server"
      puts "Serving #{@dir.yellow} on port #{Sockettp::PORT.to_s.green}"

      socket = TCPServer.new Sockettp::PORT

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

          client.puts({ status: 'OK', response: response })
        end
      end
    end
  end
end
