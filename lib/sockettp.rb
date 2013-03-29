$:.unshift File.dirname(__FILE__) # For testing

require 'json'
require 'socket'
require 'colored'

module Sockettp
  STATUSES = {
    200 => 'OK',
    404 => 'Not found'
  }

  DEFAULT_PORT = 9000

  autoload :Client, 'sockettp/client'
  autoload :Server, 'sockettp/server'
end

module URI
  class Sockettp < Generic
    DEFAULT_PORT = ::Sockettp::DEFAULT_PORT
  end

  @@schemes['SOCKETTP'] = Sockettp
end
