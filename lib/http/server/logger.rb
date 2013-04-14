require 'logger'

module HTTP
  module Server

    #
    # This module is responsible for logging messages to STDOUT.
    #
    module Logger

      module_function
      def log(msg)
        @@logger << "#{Thread.current} -- #{DateTime.now.to_s} -- #{msg}#{$/}"
      end

      class << self
        @@logger = ::Logger.new(STDOUT)
      end
    end
  end
end
