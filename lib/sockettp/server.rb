require 'date'

module Sockettp
  class Server
    def initialize(dir, port = Sockettp::DEFAULT_PORT)
      @dir = dir
      @port = port
    end

    def start
      puts "Starting Sockettp server..."
      puts "Serving #{@dir.yellow} on port #{@port.to_s.green}"

      Socket.tcp_server_loop(@port) do |socket, client_addrinfo|
        handle socket, client_addrinfo
      end
    end

    private
    def handle(client, addrinfo)
      Thread.new do
        begin
          loop do
            if client.eof?
              # puts "#{'-' * 100} end connection"
              break
            end

            input = client.gets.chomp

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

            log "#{addrinfo.ip_address}: #{input} -- #{response[:status]} #{Sockettp::STATUSES[response[:status]]}".send(response[:status] == 200 ? :green : :red)

            client.puts(response.to_json)
          end
        ensure
          # puts 'Close socket bicho'
          client.close
        end
      end
    end

    def content_for(path)
      path = File.join(@dir, path)

      return File.read(path) if File.file?(path)
      return Dir["#{path}/*"] if File.directory?(path)
    end

    def log(msg)
      puts "#{DateTime.now.to_s} -- #{msg}"
    end
  end
end
