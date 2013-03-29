module Sockettp
  module Client
    module ConnectionManager
      class << self
        def connect(host, port)
          TCPSocket.new host, port
        end
      end
    end
  end
end