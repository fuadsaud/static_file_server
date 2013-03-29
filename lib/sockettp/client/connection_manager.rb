module Sockettp
  module Client
    module ConnectionManager
      @@connections = {}

      class << self
        def connect(host, port)
          conn = @@connections[host: host, port: port]

          if conn.nil?
            @@connections[host: host, port: port] = TCPSocket.new host, port
          else
            conn
          end
        end
      end
    end
  end
end
