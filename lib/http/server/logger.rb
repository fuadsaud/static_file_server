# encoding: UTF-8

require 'logger'

module HTTP
  module Server

    #
    # This module is responsible for logging messages to STDOUT.
    #
    module Logger

      @logger = ::Logger.new(STDOUT)

      def self.log(msg)
        @logger << "#{Thread.current} -- #{DateTime.now.to_s} -- #{msg}#{$/}"
      end
    end
  end
end
