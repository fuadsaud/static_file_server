module Sockettp
  module Client
    module ConnectionManager
      @@connections = {}

      class << self
        def connect(host, port)
          puts @@connections
          conn = @@connections[host: host, port: port]

          if conn.nil? || conn.closed?
            @@connections[host: host, port: port] = TCPSocket.new host, port
          else
            conn
          end
        end
      end
    end
  end
end