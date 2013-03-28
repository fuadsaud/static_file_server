$:.unshift File.dirname(__FILE__) # For testing

require 'json'
require 'socket'
require 'colored'

module Sockettp
  DEFAULT_PORT = 9000

  require 'sockettp/client'
  require 'sockettp/server'
end

module URI
  class Sockettp < Generic
    DEFAULT_PORT = ::Sockettp::DEFAULT_PORT
  end

  @@schemes['SOCKETTP'] = Sockettp
end
