module HTTP
  module Client
    #
    # This module is responsible for the creation, and management of http
    # connections.
    #
    # Connections are stored in the _connections_ hash, indexed by a host-port
    # hash.
    #
    module ConnectionFactory
      @@connections = {}

      class << self
        #
        # This method looks up the _connections_ array checking if there is
        # already an open connections with the given host/port server. In case
        # if there isn't one, it creates a Connection object, stores it in the
        # array and returns it. In case there is an existing connection, the
        # respective Connection object is returned.
        #
        def connect(host, port)
          conn = @@connections[host: host, port: port]

          # TODO: check if the connection is still open.
          if conn.nil?
              @@connections[host: host, port: port] = Connection.new host, port
          else
            conn
          end
        end
      end
    end
  end
end
