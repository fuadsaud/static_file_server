$:.unshift File.dirname(__FILE__) # For testing

require 'socket'
require 'colored'

module Sockettp
  require 'sockettp/client'
  require 'sockettp/server'
end

module URI
  class Sockettp < Generic
    DEFAULT_PORT = 9000
  end

  @@schemes['SOCKETTP'] = Sockettp
end
