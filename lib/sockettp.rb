$:.unshift File.dirname(__FILE__) # For testing

require 'socket'
require 'colored'

module Sockettp
  PORT = 9000

  require 'sockettp/client'
  require 'sockettp/server'
end