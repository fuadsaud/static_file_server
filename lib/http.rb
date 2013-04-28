# encoding: UTF-8

$LOAD_PATH.unshift File.dirname(__FILE__) # For testing

require 'json'
require 'socket'
require 'cape-cod'

module HTTP

  require 'http/server'
  require 'http/core_ext/string'

  STATUSES = {
    200 => 'OK',
    404 => 'Not found'
  }
end
