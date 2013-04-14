require 'logger'

module HTTP
  module Server
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
