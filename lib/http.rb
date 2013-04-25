# encoding: UTF-8

$LOAD_PATH.unshift File.dirname(__FILE__) # For testing

require 'json'
require 'socket'
require 'colored'

module HTTP

  require 'http/server'

  STATUSES = {
    200 => 'OK',
    404 => 'Not found'
  }
end
