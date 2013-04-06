$:.unshift File.dirname(__FILE__) # For testing

require 'json'
require 'socket'
require 'colored'

module HTTP

  STATUSES = {
    200 => 'OK',
    404 => 'Not found'
  }

  autoload :Client, 'http/client'
  autoload :Server, 'http/server'
end
